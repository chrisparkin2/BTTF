//
//  BFNavController.m
//  bttf
//
//  Created by Admin on 2/20/15.
//  Copyright (c) 2015 bttf. All rights reserved.
//

#import "BFNavController.h"
#import "SGBDrillDownController.h"
#import "SGBDrillDownController+Setup.h"
#import "BFProductDrillDownController.h"
#import "BFOrderDrillDownController.h"
#import "PopupView.h"
#import "BFClientAPI.h"
#import "UIColor+Extensions.h"


@interface BFNavController () <BFProductDrillDownDelegate, BFOrderDrillDownDelegate>

@end

@implementation BFNavController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Setup view
    self.welcomeViewController = [self.viewControllers objectAtIndex:0];
    [self setNavigationBarHidden:YES animated:NO];
    
    // Login
    [self showLogin];
    
    // TODO: Fix persistant login
    //    [[User sharedInstance] becomeUserWithCompletion:^(NSDictionary *data, NSError *error) {
    //
    //        if (!data) {
    //            [self showLogin];
    //            return;
    //        }
    //
    //        [self proceedToMainInterface];
    //    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)proceedToMainInterface {
    
    // Preload user specific data
    [[BFClientAPI sharedAPI] preloadUserSpecificData];
    
    // Present the main interface
    self.productDrillDownController = [[BFProductDrillDownController alloc] init];
    self.productDrillDownController.delegate = self;
    [self.productDrillDownController bf_Setup];
    
    [self presentProductDrillDownController];
    
    
}

#pragma mark - Login
-(void)showLogin {
    
    PopupView *pv = [[PopupView alloc] initWithScreen:@"LoginScreen" andData:nil onScreen:nil];
    pv.delegate = self;
    pv.closeAction = @selector(loginBoxClosed);
    [self.welcomeViewController.view addSubview:pv];
}

-(void)loginBoxClosed {
    [self proceedToMainInterface];
    
}

#pragma mark - DrillDownController

- (void)presentProductDrillDownController {
    [self setViewControllers:@[self.productDrillDownController]];
    
    [self.productDrillDownController setNavigationBarsHidden:NO];
    self.productDrillDownController.leftNavigationBar.translucent = NO;
    self.productDrillDownController.rightNavigationBar.translucent = NO;
    [self.productDrillDownController.leftNavigationBar setTintColor:[UIColor colorSalmon]];
    //    [self.drillDownController.leftNavigationBar setBarTintColor:[UIColor colorFog]];
    //    [self.drillDownController.rightNavigationBar setBarTintColor:[UIColor colorFog]];

    
    self.productDrillDownController.leftControllerWidth = [self leftControllerShortWidth];
    
    [self.productDrillDownController presentCategoryController:BFCategoryMain object:nil];
    
    
}

- (void)presentOrderDrillDownController {
    
    // Present the main interface
    if (!self.orderDrillDownController) {
        self.orderDrillDownController = [[BFOrderDrillDownController alloc] init];
        [self.orderDrillDownController bf_Setup];
        self.orderDrillDownController.delegate = self;
    }
    
    [self setViewControllers:@[self.orderDrillDownController]];
    
    [self.orderDrillDownController setNavigationBarsHidden:NO];
    self.orderDrillDownController.leftNavigationBar.translucent = NO;
    self.orderDrillDownController.rightNavigationBar.translucent = NO;
    [self.orderDrillDownController.leftNavigationBar setTintColor:[UIColor colorSalmon]];
    
    
    self.orderDrillDownController.leftControllerWidth = [self leftControllerShortWidth];

    [self.orderDrillDownController presentSupplierController];
    
}

- (CGFloat)leftControllerWideWidth {
    return [UIScreen mainScreen].bounds.size.width * 0.6;
}

- (CGFloat)leftControllerShortWidth {
    return [UIScreen mainScreen].bounds.size.width * 0.4;
}

#pragma mark - BFProductDrillDown Delegate 
- (void)didTapOrderButton {
    
    [self presentOrderDrillDownController];
    
    
}

#pragma mark - BFOrderDrillDown Delegate
- (void)didTapProductButton {
    
    [self presentProductDrillDownController];

}




@end
