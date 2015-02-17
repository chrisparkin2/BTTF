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
#import "BFProductViewController.h"
#import "BFClientAPI.h"
#import "PopupView.h"
#import "User.h"
#import "UIColor+Extensions.h"

@interface AppDelegate () <BFCategoryVCDelegate, BFProductVCDelegate>


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
    
    // Preload non-user specific data
    [[BFClientAPI sharedAPI] preloadGenericData];

    // Login
    [self showLogin];
    
    // TODO: Trying to create persistant login
//    [[User sharedInstance] becomeUserWithCompletion:^(NSDictionary *data, NSError *error) {
//        
//        if (!data) {
//            [self showLogin];
//            return;
//        }
//        
//        [self proceedToMainInterface];        
//    }];
    
    

    
    return YES;
}

-(void)proceedToMainInterface {
    
#ifdef DEBUG
    [self runAdmin];
#endif
    
    // Preload user specific data
    [[BFClientAPI sharedAPI] preloadUserSpecificData];
    
    // Present the main interface
    [self setupDrillDownController];
    
    [self presentDrillDownController];

    
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

#pragma mark - drillDownController
- (void)setupDrillDownController {
    
    SGBDrillDownController *drillDownController = [[SGBDrillDownController alloc] init];
    self.drillDownController = drillDownController;
    self.drillDownController.leftPlaceholderController = [UIViewController new];
    self.drillDownController.rightPlaceholderController = [UIViewController new];
    self.drillDownController.view.backgroundColor = [UIColor whiteColor];
    
    self.drillDownController.leftPlaceholderController.view.backgroundColor = [UIColor clearColor];
    self.drillDownController.rightPlaceholderController.view.backgroundColor = [UIColor clearColor];
    
   

}

- (void)presentDrillDownController {
    [self.navController setViewControllers:@[self.drillDownController]];
    
    [self.drillDownController setNavigationBarsHidden:NO];
    self.drillDownController.leftNavigationBar.translucent = NO;
    self.drillDownController.rightNavigationBar.translucent = NO;
    [self.drillDownController.leftNavigationBar setTintColor:[UIColor colorSalmon]];
//    [self.drillDownController.leftNavigationBar setBarTintColor:[UIColor colorFog]];
//    [self.drillDownController.rightNavigationBar setBarTintColor:[UIColor colorFog]];
    
    
    self.drillDownController.leftControllerWidth = [self leftControllerShortWidth];
    
    [self pushCategoryController:BFCategoryMain object:nil];
}

- (CGFloat)leftControllerWideWidth {
    return [UIScreen mainScreen].bounds.size.width * 0.6;
}

- (CGFloat)leftControllerShortWidth {
    return [UIScreen mainScreen].bounds.size.width * 0.4;
}

#pragma mark categoryController
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

#pragma mark productController
- (void) presentProductController:(NSInteger)index object:(id)object{
    
    BFProductViewController* lastVC = (BFProductViewController*)[self.drillDownController.viewControllers lastObject];
    
    // If current vc is last on drilldown stack, then push
    if (index > lastVC.categoryIndex) {
        [self pushProductController:index object:object];
    }
    // Else push
    else {
        [self reloadRightProductController:index object:object];
    }
}

- (void) pushProductController:(NSInteger)index object:(id)object{
    
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    BFProductViewController* productVC = (BFProductViewController*)[storyboard instantiateViewControllerWithIdentifier:@"ProductVC"];
    productVC.categoryIndex = index;
    productVC.parentObject = object;
    productVC.productDelegate = self;
    
    [self.drillDownController pushViewController:productVC animated:YES completion:nil];
}

- (void) reloadRightProductController:(NSInteger)index object:(id)object{
    
    BFProductViewController* rightVC = (BFProductViewController*)[self.drillDownController.viewControllers lastObject];
    rightVC.parentObject = object;
    [rightVC reloadData];
}

#pragma mark - BFCategoryVCDelegate
- (void)didTapCellWithObject:(id)object tableViewIndex:(NSInteger)tableViewIndex {

    // Push a CategoryVC?
    if (tableViewIndex < BFCategoryProduct) {
        [self presentCategoryController:++tableViewIndex object:object];
    }
    // Push a ProductVC
    else {
        [self presentProductController:++tableViewIndex object:object];
    }

}

#pragma mark - BFProductVCDelegate
- (void)didTapAddNewProduct:(id)parentObject {
    NSDictionary* data = @{ @"parentObject" : parentObject };
    PopupView *pv = [[PopupView alloc] initWithScreen:@"AddProduct" andData:data onScreen:nil];
    pv.delegate = self;
    pv.closeAction = @selector(addProductBoxClosed);
    [self.drillDownController.view addSubview:pv];
    [self.drillDownController.view bringSubviewToFront:pv];
}

- (void)didTapProduct:(UserProduct*)userProduct parentObject:(id)parentObject {
    NSDictionary* data = @{ @"parentObject" : parentObject,
                            @"userProduct" : userProduct };
    
    PopupView *pv = [[PopupView alloc] initWithScreen:@"AddProduct" andData:data onScreen:nil];
    pv.delegate = self;
    pv.closeAction = @selector(addProductBoxClosed);
    [self.drillDownController.view addSubview:pv];
    [self.drillDownController.view bringSubviewToFront:pv];
}



-(void)addProductBoxClosed {
    
}
#ifdef DEBUG
#pragma mark - Admin
- (void)runAdmin {
    
//    [[BFClientAPI sharedAPI] processCategoriesFromCSV];
    
}

#endif
@end
