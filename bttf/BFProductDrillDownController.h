//
//  BFProductNavController.h
//  bttf
//
//  Created by Admin on 2/20/15.
//  Copyright (c) 2015 bttf. All rights reserved.
//

#import "SGBDrillDownController.h"

@interface BFProductDrillDownController : SGBDrillDownController

//- (void) pushCategoryController:(NSInteger)index object:(id)object;
- (void) presentCategoryController:(NSInteger)index object:(id)object;
- (void) presentProductController:(NSInteger)index object:(id)object;

@end
