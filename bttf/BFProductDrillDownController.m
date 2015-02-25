//
//  BFProductNavController.m
//  bttf
//
//  Created by Admin on 2/20/15.
//  Copyright (c) 2015 bttf. All rights reserved.
//

#import "BFProductDrillDownController.h"
#import "BFCategoryViewController.h"
#import "BFProductViewController.h"
#import "UIColor+Extensions.h"
#import "PopupView.h"
#import "BFClientAPI.h"

@interface BFProductDrillDownController () <BFCategoryVCDelegate, BFProductVCDelegate>

- (void)didTapOrderButton:(id)sender;

@end

@implementation BFProductDrillDownController
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setLeftNavigationItem:(NSInteger)index {
    // Left bar button (defaults to "back" when there's a hidden leftViewController (see SGBDrillDownController)
    if (index == BFCategoryMain) {
        
        UIBarButtonItem* leftBarButton = [[UIBarButtonItem alloc] initWithTitle:@"< Orders" style:UIBarButtonItemStylePlain target:self action:@selector(didTapOrderButton:)];
        [leftBarButton setTitleTextAttributes:@{
                                                NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                                NSForegroundColorAttributeName: [UIColor colorSalmon]
                                                } forState:UIControlStateNormal];
        self.leftViewController.navigationItem.leftBarButtonItem = leftBarButton;
    }
}

#pragma mark CategoryController
- (void) presentCategoryController:(NSInteger)index object:(id)object{

    BFCategoryViewController* lastVC = (BFCategoryViewController*)[self.viewControllers lastObject];
    
    // If current vc is last on drilldown stack, then push
    if (!lastVC || index > lastVC.categoryIndex) {
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
    
    [self pushViewController:categoryVC animated:YES completion:^{
        
        // Set the navigation item
        [self setLeftNavigationItem:index];

    }];
}

- (void) reloadRightCategoryController:(NSInteger)index object:(id)object{
    
    BFCategoryViewController* rightVC = (BFCategoryViewController*)[self.viewControllers lastObject];
    rightVC.parentObject = object;
    [rightVC reloadData];
}

#pragma mark ProductController
- (void) presentProductController:(NSInteger)index object:(id)object{
    
    BFProductViewController* lastVC = (BFProductViewController*)[self.viewControllers lastObject];
    
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
    
    [self pushViewController:productVC animated:YES completion:nil];
}

- (void) reloadRightProductController:(NSInteger)index object:(id)object{
    
    BFProductViewController* rightVC = (BFProductViewController*)[self.viewControllers lastObject];
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

- (void)didTapCellForWholeAnimal {
    if (self.delegate && [self.delegate respondsToSelector:@selector(presentWholeAnimalScreen)]) {
        [self.delegate presentWholeAnimalScreen];
    }
}

#pragma mark - BFProductVCDelegate
- (void)didTapAddNewProduct:(id)parentObject {
    NSDictionary* data = @{ @"parentObject" : parentObject };
    PopupView *pv = [[PopupView alloc] initWithScreen:@"AddProduct" andData:data onScreen:nil];
    pv.delegate = self;
    pv.closeAction = @selector(addProductBoxClosed);
    [self.view addSubview:pv];
    [self.view bringSubviewToFront:pv];
}

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
- (void)didTapOrderButton:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTapOrderButton)]) {
        [self.delegate didTapOrderButton];
    }
}

@end
