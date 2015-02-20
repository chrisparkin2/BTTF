//
//  SGBDrillDownController+Setup.m
//  bttf
//
//  Created by Admin on 2/20/15.
//  Copyright (c) 2015 bttf. All rights reserved.
//

#import "SGBDrillDownController+Setup.h"

@implementation SGBDrillDownController (Setup)

- (void)bf_Setup {
    
    self.leftPlaceholderController = [UIViewController new];
    self.rightPlaceholderController = [UIViewController new];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.leftPlaceholderController.view.backgroundColor = [UIColor clearColor];
    self.rightPlaceholderController.view.backgroundColor = [UIColor clearColor];
    
}
@end
