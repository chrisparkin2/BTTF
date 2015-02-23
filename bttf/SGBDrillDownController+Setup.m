//
//  SGBDrillDownController+Setup.m
//  bttf
//
//  Created by Admin on 2/20/15.
//  Copyright (c) 2015 bttf. All rights reserved.
//

#import "SGBDrillDownController+Setup.h"
#import "BFConstants.h"
#import "UIColor+Extensions.h"

@implementation SGBDrillDownController (Setup)

- (void)bf_Setup {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.leftPlaceholderController = [UIViewController new];
    self.rightPlaceholderController = [UIViewController new];

    self.leftPlaceholderController.view.backgroundColor = [UIColor clearColor];
    self.rightPlaceholderController.view.backgroundColor = [UIColor clearColor];
    
    [self setNavigationBarsHidden:NO];
    self.leftNavigationBar.translucent = NO;
    self.rightNavigationBar.translucent = NO;
    [self.leftNavigationBar setTintColor:[UIColor colorSalmon]];
    
    
}

@end
