//
//  Sales.h
//  bttf
//
//  Created by Ramsel J Ruiz on 4/5/15.
//  Copyright (c) 2015 bttf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Screen.h"

@class UserProduct;

@interface Sales : Screen

@property (nonatomic, strong) UserProduct* userProduct;

@property (nonatomic, strong) id parentObject;

@end