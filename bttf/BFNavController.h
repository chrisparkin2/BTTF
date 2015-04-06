//
//  BFNavController.h
//  bttf
//
//  Created by Admin on 2/20/15.
//  Copyright (c) 2015 bttf. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BFProductDrillDownController;
@class BFOrderDrillDownController;

@interface BFNavController : UINavigationController

@property (nonatomic, strong) UIViewController* welcomeViewController;
@property (nonatomic, strong) BFProductDrillDownController* productDrillDownController;
@property (nonatomic, strong) BFOrderDrillDownController* orderDrillDownController;
@end
