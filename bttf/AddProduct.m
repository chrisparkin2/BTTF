//
//  BFAddProductViewController.m
//  bttf
//
//  Created by Admin on 2/12/15.
//  Copyright (c) 2015 bttf. All rights reserved.
//

#import "AddProduct.h"
#import "UserProduct.h"
#import "CategoryProduct.h"
#import "BFClientAPI.h"
#import "BFConstants.h"
#import "PopupView.h"
#import "User.h"

typedef enum {
    BFAddProductTextFieldProduct,
    BFAddProductTextFieldSupplier,
    BFAddProductTextFieldPrice,
    BFAddProductTextFieldQuantityBulk,
    BFAddProductTextFieldQuantityPerCase,
    BFAddProductTextFieldQuantityUnits
} BFAddProductTextFieldIndex;

@interface AddProduct () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *productNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *supplerNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *priceLabel;
@property (weak, nonatomic) IBOutlet UITextField *quantityBulkTextField;
@property (weak, nonatomic) IBOutlet UITextField *quantityPerCaseTextField;
@property (weak, nonatomic) IBOutlet UITextField *quantityUnitsTextField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;
- (IBAction)didTapSave:(id)sender;
- (IBAction)didTapCancel:(id)sender;

@end

@implementation AddProduct

-(void)setup{
    
    self.navigationController.navigationBar.topItem.title = @"Add Product";
    
    self.parentObject = self.passedData[@"parentObject"];
    self.userProduct = self.passedData[@"userProduct"];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Pre-populate fields
    if (self.userProduct) {
        self.productNameLabel.text = self.userProduct.name;
        self.supplerNameLabel.text = self.userProduct.supplier;
        self.priceLabel.text = [self.userProduct.price stringValue];
        self.quantityBulkTextField.text = [self.userProduct.quantityBulk stringValue];
        self.quantityPerCaseTextField.text = [self.userProduct.quantityPerCase stringValue];
        self.quantityUnitsTextField.text = [self.userProduct.quantityUnits stringValue];
    }
}

#pragma mark - Data
- (void)calculateUnits {
    if (self.quantityBulkTextField.text.length > 0 && self.quantityPerCaseTextField.text.length > 0) {
        int bulk = [self.quantityBulkTextField.text intValue];
        int perCase = [self.quantityPerCaseTextField.text intValue];
        int total = bulk * perCase;
        
        self.quantityUnitsTextField.text = [@(total) stringValue];
    }
}

- (void)createNewUserProduct {
    
    // Create new
    self.userProduct = [UserProduct new];
    
    
    // Populate with data from view
    self.userProduct = [self setUserProductFields:self.userProduct];
    
    // Save
    [self.activityView startAnimating];
    [[BFClientAPI sharedAPI] createUserProduct:self.userProduct withSuccess:^{
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

- (void)saveExistingUserProduct {
    
    // Populate with data from view
    self.userProduct = [self setUserProductFields:self.userProduct];
    
    // Save
    [self.activityView startAnimating];
    [[BFClientAPI sharedAPI] updateUserProduct:self.userProduct withSuccess:^{
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

- (UserProduct*)setUserProductFields:(UserProduct*)userProduct {
    // Set all the fields
    CategoryProduct* categoryProduct = (CategoryProduct*)self.parentObject;
    userProduct.categoryProductId = categoryProduct.objectId;
    
    userProduct.name = [self.productNameLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    userProduct.supplier = [self.supplerNameLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    userProduct.price = @([[self.priceLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] floatValue]);
    userProduct.quantityBulk = @([[self.quantityBulkTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] floatValue]);
    userProduct.quantityPerCase = @([[self.quantityPerCaseTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] floatValue]);
    userProduct.quantityUnits = @([[self.quantityUnitsTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] floatValue]);
    userProduct.userId = [User sharedInstance].objectId;

    return userProduct;
}

#pragma - mark TextField Delegate Methods
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    // Calculate units
    if (textField.tag == BFAddProductTextFieldQuantityBulk ||
        textField.tag == BFAddProductTextFieldQuantityPerCase) {
        [self calculateUnits];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];

    // priceTextField -- Ensure only one decimal
    if (textField.tag == BFAddProductTextFieldPrice) {
        
        if (newString.length == 0) return YES;
        
        // Allow only numeric && decimals
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        NSNumber * n = [f numberFromString:newString];
        if (!n) return NO;
    }

    
    if (textField.tag == BFAddProductTextFieldQuantityBulk ||
        textField.tag == BFAddProductTextFieldQuantityPerCase ||
        textField.tag == BFAddProductTextFieldQuantityUnits) {
        
        if (newString.length == 0) return YES;
        
        // Allow only numeric
        NSScanner *scanner = [NSScanner scannerWithString:newString];
        BOOL isNumeric = [scanner scanInteger:NULL] && [scanner isAtEnd];
        if (!isNumeric) return NO;
    }
    
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
    if (self.quantityBulkTextField.text.length <= 0) { [self hasErrorWithLocalizedDescription:@"Please enter a bulk quantity"]; return; }
    if (self.quantityPerCaseTextField.text.length <= 0) { [self hasErrorWithLocalizedDescription:@"Please enter a quantity per case"]; return; }
    
    // Calculate units
    [self calculateUnits];

    // Create new if not already set
    if (!self.userProduct) {
        [self createNewUserProduct];
    }
    else {
        [self saveExistingUserProduct];
    }
        

    

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
