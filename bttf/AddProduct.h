//
//  BFAddProductViewController.h
//  bttf
//
//  Created by Admin on 2/12/15.
//  Copyright (c) 2015 bttf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Screen.h"

@class UserProduct;

@interface AddProduct : Screen

@property (nonatomic, strong) UserProduct* userProduct;

@property (nonatomic, strong) id parentObject;

@end
