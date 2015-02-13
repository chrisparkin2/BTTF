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
    
    [self runAdmin];
    
    
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
    
    [self.drillDownController setNavigationBarsHidden:NO];
    
    self.drillDownController.leftPlaceholderController.view.backgroundColor = [UIColor brownColor];
    self.drillDownController.rightPlaceholderController.view.backgroundColor = [UIColor greenColor];

}

- (void)presentDrillDownController {
    [self.navController setViewControllers:@[self.drillDownController]];
//    [self.navController setNavigationBarHidden:NO animated:YES];
    
    [self pushCategoryController:BFCategoryMain object:nil];
}

- (void) presentCategoryController:(NSInteger)index object:(id)object{

    BFCategoryViewController* lastVC = (BFCategoryViewController*)[self.drillDownController.viewControllers lastObject];
    
    // If current vc is last on drilldown stack, then push
    if (index > lastVC.categoryIndex) {
        [self pushCategoryController:index object:object];
    }
    // Else push
    else {
        [self reloadRightCategoryController:index object:object];
    }
    
}

- (void) pushCategoryController:(NSInteger)index object:(id)object{
    
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BFCategoryViewController* categoryVC = (BFCategoryViewController*)[storyboard instantiateViewControllerWithIdentifier:@"CategoryViewController"];
    categoryVC.delegate = self;
    categoryVC.categoryIndex = index;
    categoryVC.parentObject = object;
    
    [self.drillDownController pushViewController:categoryVC animated:YES completion:nil];
}

- (void) reloadRightCategoryController:(NSInteger)index object:(id)object{

    BFCategoryViewController* rightVC = (BFCategoryViewController*)[self.drillDownController.viewControllers lastObject];
    rightVC.parentObject = object;
    [rightVC reloadData];
}

- (void) presentProductController:(id)object {
    
    PopupView *pv = [[PopupView alloc] initWithVC:@"ProductVC" andData:nil onVC:self.drillDownController];
    pv.delegate = self;
    pv.closeAction = @selector(loginBoxClosed);
    [self.drillDownController.view addSubview:pv];

}

#pragma mark - BFCategoryVCDelegate 
- (void)didTapCellWithObject:(id)object tableViewIndex:(NSInteger)tableViewIndex {

    // Push a CategoryVC?
    if (tableViewIndex < BFCategoryProduct) {
        [self presentCategoryController:++tableViewIndex object:object];
    }
    // Push a ProductVC
    else {
        
        
    }

}

#ifdef DEBUG
#pragma mark - Admin
- (void)runAdmin {
    
//    [[BFClientAPI sharedAPI] processCategoriesFromCSV];
    
}

#endif
@end
