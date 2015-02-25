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
#import "BFLogoViewController.h"
#import "PopupView.h"
#import "BFClientAPI.h"
#import "BFConstants.h"
#import "ScreenNavigation.h"
#import "User.h"


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
    
    if (!self.productDrillDownController) {
        self.productDrillDownController = [[BFProductDrillDownController alloc] init];
        self.productDrillDownController.delegate = self;
        [self.productDrillDownController bf_Setup];
    }
    
    [self showProductDrillDownController];
    
    self.productDrillDownController.leftControllerWidth = [self leftControllerShortWidth];
    
    [self.productDrillDownController presentCategoryController:BFCategoryMain object:nil];
    
    // Add the right logoVC
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BFLogoViewController* rightLogoVC = (BFLogoViewController*)[storyboard instantiateViewControllerWithIdentifier:@"IconVC"];
    self.productDrillDownController.rightPlaceholderController = rightLogoVC;
    rightLogoVC.promptLabel.text = @"Add Products";

}

- (void)showProductDrillDownController {

    [self setViewControllers:@[self.productDrillDownController]];
}


- (void)presentOrderDrillDownController {
    
    if (!self.orderDrillDownController) {
        self.orderDrillDownController = [[BFOrderDrillDownController alloc] init];
        [self.orderDrillDownController bf_Setup];
        self.orderDrillDownController.delegate = self;
    }
    
    [self showOrderDrillDownController];
    
    self.orderDrillDownController.leftControllerWidth = [self leftControllerShortWidth];
    
    [self.orderDrillDownController presentSupplierController];
    
    // Add the right logoVC
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BFLogoViewController* rightLogoVC = (BFLogoViewController*)[storyboard instantiateViewControllerWithIdentifier:@"IconVC"];
    self.orderDrillDownController.rightPlaceholderController = rightLogoVC;
    rightLogoVC.promptLabel.text = @"Add Orders";

}

- (void)showOrderDrillDownController {
    
    [self setViewControllers:@[self.orderDrillDownController]];
}

- (CGFloat)leftControllerWideWidth {
    return [UIScreen mainScreen].bounds.size.width * 0.6;
}

- (CGFloat)leftControllerShortWidth {
    return [UIScreen mainScreen].bounds.size.width * 0.4;
}

#pragma mark - BFProductDrillDown Delegate 
- (void)didTapOrderButton {

    if (!self.orderDrillDownController) {
        [self presentOrderDrillDownController];
        return;
    }

    [self showOrderDrillDownController];
}

- (void)presentWholeAnimalScreen {
    
    // Present a screen in a modal
    // NOTE: This is a hack to present the original dev's whole animal flow
    ScreenNavigation* screenNavigation = [[ScreenNavigation alloc] init];
    [screenNavigation startWithScreen:@"MainScreen" data:nil animated:NO];
    [self presentViewController:screenNavigation animated:YES completion:nil];
    
    [User sharedInstance].meatData = [[User sharedInstance] meatDictionary];
    
    [[User sharedInstance] loadMeatFromFile];


}
    

#pragma mark - BFOrderDrillDown Delegate
- (void)didTapProductButton {

    if (!self.productDrillDownController) {
        [self presentProductDrillDownController];
        return;
    }

    [self showProductDrillDownController];
}




@end
