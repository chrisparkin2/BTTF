//
//  BFProductNavController.h
//  bttf
//
//  Created by Admin on 2/20/15.
//  Copyright (c) 2015 bttf. All rights reserved.
//

#import "SGBDrillDownController.h"

@protocol BFProductDrillDownDelegate;

@interface BFProductDrillDownController : SGBDrillDownController

- (void) presentCategoryController:(NSInteger)index object:(id)object;
- (void) presentProductController:(NSInteger)index object:(id)object;

@property (nonatomic, weak) id<BFProductDrillDownDelegate> delegate;

@end

@protocol BFProductDrillDownDelegate <NSObject>

- (void)didTapOrderButton;

@end
