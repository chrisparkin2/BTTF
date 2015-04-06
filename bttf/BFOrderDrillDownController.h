//
//  BFOrderDrillDownController.h
//  bttf
//
//  Created by Admin on 2/20/15.
//  Copyright (c) 2015 bttf. All rights reserved.
//

#import "SGBDrillDownController.h"

@protocol BFOrderDrillDownDelegate;

@interface BFOrderDrillDownController : SGBDrillDownController

- (void) presentSupplierController;

@property (nonatomic, weak) id<BFOrderDrillDownDelegate> delegate;


@end

@protocol BFOrderDrillDownDelegate <NSObject>

- (void)didTapProductButton;
- (void)didTapAdminButton;
@end