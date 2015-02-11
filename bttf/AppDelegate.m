//
//  AppDelegate.m
//  bttf
//
//  Created by Admin on 2/10/15.
//  Copyright (c) 2015 bttf. All rights reserved.
//

#import "AppDelegate.h"
#import "SGBDrillDownController.h"
#import "BFCategoryViewController.h"
#import "BFClientAPI.h"
#import "PopupView.h"
#import "User.h"

#define kMaxCategoryLevels 2

@interface AppDelegate () <BFCategoryVCDelegate>


@property (nonatomic, strong) UINavigationController* navController;
@property (nonatomic, strong) UIViewController* welcomeViewController;
@property (nonatomic, strong) SGBDrillDownController* drillDownController;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // Setup view
    self.navController = (UINavigationController*)self.window.rootViewController;
    self.welcomeViewController = [self.navController.viewControllers objectAtIndex:0];
    [self.navController setNavigationBarHidden:YES animated:NO];

    [self showLogin];
    
    return YES;
}

#pragma mark - Login
-(void)showLogin {
    
    PopupView *pv = [[PopupView alloc] initWithScreen:@"LoginScreen" andData:nil onScreen:nil];
    pv.delegate = self;
    pv.closeAction = @selector(loginBoxClosed);
    [self.welcomeViewController.view addSubview:pv];
}

-(void)loginBoxClosed {
    
    
    // Present the main interface
    [self setupDrillDownController];

    [self presentDrillDownController];


    
//    BFCategory* bfCategory = [BFCategory new];
//    bfCategory.name = @"Vegetables";
//
//    bfCategory.level = @(1);
//    
//    [[BFClientAPI sharedAPI] createCategory:bfCategory withSuccess:^{
//        
//        
//    } failure:^(NSError *error) {
//        
//        
//    }];

}

#pragma mark - drillDownController
- (void)setupDrillDownController {
    
    SGBDrillDownController *drillDownController = [[SGBDrillDownController alloc] init];
    self.drillDownController = drillDownController;
    self.drillDownController.leftPlaceholderController = [UIViewController new];
    self.drillDownController.rightPlaceholderController = [UIViewController new];
    
    [self.drillDownController setNavigationBarsHidden:YES];
    
    self.drillDownController.leftPlaceholderController.view.backgroundColor = [UIColor brownColor];
    self.drillDownController.rightPlaceholderController.view.backgroundColor = [UIColor greenColor];

}

- (void)presentDrillDownController {
    [self.navController setViewControllers:@[self.drillDownController]];
    [self.navController setNavigationBarHidden:NO animated:YES];
    
    [self pushCategoryController:0];
}



- (void) pushCategoryController:(NSInteger)index{
    
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BFCategoryViewController* categoryVC = (BFCategoryViewController*)[storyboard instantiateViewControllerWithIdentifier:@"CategoryViewController"];
    categoryVC.delegate = self;
    categoryVC.categoryIndex = index;
    
    [self.drillDownController pushViewController:categoryVC animated:YES completion:nil];
}


//- (NSArray*) dataSourceForCategoryIndex:(NSInteger)index parentCategory:(Category*)parentCategory {
//    
//}

#pragma mark - BFCategoryVCDelegate 
- (void)didTapCellAtIndex:(NSInteger)index tableViewIndex:(NSInteger)tableViewIndex {
    
    if (tableViewIndex < kMaxCategoryLevels) {
        [self pushCategoryController:++tableViewIndex];

    }
}



@end
