//
//  BFOrderDrillDownController.m
//  bttf
//
//  Created by Admin on 2/20/15.
//  Copyright (c) 2015 bttf. All rights reserved.
//

#import "BFOrderDrillDownController.h"
#import "BFSupplierViewController.h"
#import "BFOrdersViewController.h"
#import "UIColor+Extensions.h"
#import "PopupView.h"
#import "UserProduct.h"

@interface BFOrderDrillDownController () <BFSupplierVCDelegate, BFOrdersVCDelegate>

@end

@implementation BFOrderDrillDownController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void) setLeftNavigationItem {
    // Left bar button (defaults to "back" when there's a hidden leftViewController (see SGBDrillDownController)
    if ([self.leftViewController isKindOfClass:[BFSupplierViewController class]]) {
        
        UIBarButtonItem* leftBarButton = [[UIBarButtonItem alloc] initWithTitle:@"< Products" style:UIBarButtonItemStylePlain target:self action:@selector(didTapProductButton:)];
        [leftBarButton setTitleTextAttributes:@{
                                             NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                             NSForegroundColorAttributeName: [UIColor colorSalmon]
                                             } forState:UIControlStateNormal];
        self.leftViewController.navigationItem.leftBarButtonItem = leftBarButton;
        
    }
}

#pragma mark SupplierController
- (void) presentSupplierController {
    
    if ([self.leftViewController isKindOfClass:[BFSupplierViewController class]]) return;
    
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BFSupplierViewController* supplierVC = (BFSupplierViewController*)[storyboard instantiateViewControllerWithIdentifier:@"SupplierViewController"];
    supplierVC.delegate = self;
    
    [self pushViewController:supplierVC animated:YES completion:^{
        
        // Set the navigation item
        [self setLeftNavigationItem];
        
    }];
}

#pragma mark OrdersController
- (void) presentOrdersController:(id)parentObject {
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BFOrdersViewController* ordersVC = (BFOrdersViewController*)[storyboard instantiateViewControllerWithIdentifier:@"OrdersViewController"];
    ordersVC.delegate = self;
    ordersVC.parentObject = parentObject;
    
    [self pushViewController:ordersVC animated:YES completion:nil];
}

- (void) reloadRightProductController:(id)parentObject{
    
    BFOrdersViewController* ordersVC = (BFOrdersViewController*)[self.viewControllers lastObject];
    ordersVC.parentObject = parentObject;
    [ordersVC reloadData];
}

#pragma mark - BFSupplierVCDelegate
- (void)didTapCellWithObject:(id)object {
    
    // If the right VC has been pushed already, reload
    if ([[self.viewControllers lastObject] isKindOfClass:[BFOrdersViewController class]]) {
        [self reloadRightProductController:object];
    }
    // Else push
    else {
        [self presentOrdersController:object];
    }



}

#pragma mark - BFOrderVCDelegate
- (void)didTapProduct:(UserProduct*)userProduct parentObject:(id)parentObject {
    NSDictionary* data = @{ @"parentObject" : parentObject,
                            @"userProduct" : userProduct };
    
    PopupView *pv = [[PopupView alloc] initWithScreen:@"AddProduct" andData:data onScreen:nil];
    pv.delegate = self;
    pv.closeAction = @selector(addProductBoxClosed);
    [self.view addSubview:pv];
    [self.view bringSubviewToFront:pv];
}

-(void)addProductBoxClosed {
    
}

#pragma mark - Actions
- (void)didTapProductButton:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTapProductButton)]) {
        [self.delegate didTapProductButton];
    }
}

@end
