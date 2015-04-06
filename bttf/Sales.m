//
//  Sales.m
//  bttf
//
//  Created by Ramsel J Ruiz on 4/5/15.
//  Copyright (c) 2015 bttf. All rights reserved.
//

#import "Sales.h"
#import "UserProduct.h"
#import "CategoryProduct.h"
#import "BFClientAPI.h"
#import "BFConstants.h"
#import "PopupView.h"
#import "User.h"

typedef enum {
    BFSalesTextFieldProduct,
    BFSalesTextFieldSupplier,
    BFSalesTextFieldPrice,
    BFSalesTextFieldQuantityToRemove,
    BFSalesTextFieldQuantityUnits,
} BFSalesTextFieldIndex;

@interface Sales () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *productNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *supplerNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *priceLabel;

@property (weak, nonatomic) IBOutlet UITextField *quantityToRemoveTextField;
@property (weak, nonatomic) IBOutlet UITextField *quantityUnitsTextField;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;
- (IBAction)didTapSave:(id)sender;
- (IBAction)didTapCancel:(id)sender;

@end

@implementation Sales

-(void)setup{
    
    self.parentObject = self.passedData[@"parentObject"];
    self.userProduct = self.passedData[@"userProduct"];
    
    // Set navTitle
    NSString* navTitle = @"Update Sales";
    self.navigationController.navigationBar.topItem.title = navTitle;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self prePopulateFields];
}

#pragma mark - Data
- (void)calculateUnits:(NSString*)newQuantity {
    
    if (newQuantity.length > 0) {
        
        int quantityToRemove = [newQuantity intValue];
        int originalQuantity = [self.userProduct.quantityUnits intValue];
        int updatedQuantity = originalQuantity - quantityToRemove;
        
        self.quantityUnitsTextField.text = [@(updatedQuantity) stringValue];
    }
    
}



- (void)saveExistingUserProduct {
    
    // Populate with data from view
    if ([self setUserProductValuesFromTextFields:self.userProduct]) {
        self.userProduct = [self setUserProductValuesFromTextFields:self.userProduct];
    }
    
    
    // Save
    [self.activityView startAnimating];
    [self.view bringSubviewToFront:self.activityView];
    [[BFClientAPI sharedAPI] updateUserProduct:self.userProduct withSuccess:^(id objectUpdated) {
        [self.activityView stopAnimating];
        
        NSDictionary* userInfo = @{ kBFNotificationInfoUserProductKey : self.userProduct };
        [[NSNotificationCenter defaultCenter] postNotificationName:kBFNotificationCenterDidUpdateUserProductKey object:nil userInfo:userInfo];
        
        PopupView *pv = self.passedData[@"popup_vc"];
        [pv closeBox:nil];
        
    } failure:^(NSError *error) {
        [self.activityView stopAnimating];
        [self hasError:error];
    }];
    
    
}


- (UserProduct*)setUserProductValuesFromTextFields:(UserProduct*)userProduct {
    
    
    userProduct.name = [self.productNameLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    userProduct.supplier = [self.supplerNameLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    userProduct.price = @([[self.priceLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] floatValue]);
    
    userProduct.quantityUnits = @([[self.quantityUnitsTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] floatValue]);
    
    
    userProduct.userId = [User sharedInstance].objectId;
    
    return userProduct;
}

- (void)prePopulateFields {
    
    // Pre-populate fields
    if (self.userProduct) {
        self.productNameLabel.text = self.userProduct.name;
        self.supplerNameLabel.text = self.userProduct.supplier;
        self.priceLabel.text = [self.userProduct.price stringValue];
        self.quantityUnitsTextField.text = [self.userProduct.quantityUnits stringValue];
    }
}

#pragma - mark TextField Delegate Methods
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    // Calculate units
    [self calculateUnits:textField.text];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if ([newString integerValue] > [self.userProduct.quantityUnits integerValue]) return NO;

    if (newString.length == 0) newString = @"0";
    
    // Calculate units
    [self calculateUnits:newString];

    return YES;
    
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - Actions
- (IBAction)didTapSave:(id)sender {
    
    if (self.productNameLabel.text.length <= 0) { [self hasErrorWithLocalizedDescription:@"Please enter a product name"]; return; }
    if (self.priceLabel.text.length <= 0) { [self hasErrorWithLocalizedDescription:@"Please enter a price"]; return; }
    if (self.supplerNameLabel.text.length <= 0) { [self hasErrorWithLocalizedDescription:@"Please enter a supplier"]; return; }
    if (self.quantityToRemoveTextField.text.length <= 0) { [self hasErrorWithLocalizedDescription:@"Please enter a quantity to remove"]; return; }
    
    // Calculate units
    [self calculateUnits:self.quantityToRemoveTextField.text];
    
    [self saveExistingUserProduct];
    
    
    // Post Notification
    NSDictionary* userInfo = @{ @"userProduct" : self.userProduct };
    [[NSNotificationCenter defaultCenter] postNotificationName:kBFNotificationCenterDidUpdateSalesKey object:nil userInfo:userInfo];
    
}


- (IBAction)didTapCancel:(id)sender {
    PopupView *pv = self.passedData[@"popup_vc"];
    [pv closeBox:nil];
}

//#pragma mark - Delegate
//-(void)didAddUserProduct:(UserProduct*)userProduct{
//    if (self.delegate && [self.delegate respondsToSelector:@selector(didAddUserProduct:)]) {
//        [self.delegate didAddUserProduct:userProduct];
//    }
//}

@end