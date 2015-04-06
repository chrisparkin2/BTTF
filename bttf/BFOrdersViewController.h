//
//  BFOrdersViewController.h
//  bttf
//
//  Created by Admin on 2/20/15.
//  Copyright (c) 2015 bttf. All rights reserved.
//

#import "BFBaseViewController.h"

@class UserProduct;

@protocol BFOrdersVCDelegate;

@interface BFOrdersViewController : BFBaseViewController


@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray* objects;

@property (nonatomic, strong) id parentObject;

@property (nonatomic, weak) id<BFOrdersVCDelegate> delegate;

- (void)reloadData;


@end



@protocol BFOrdersVCDelegate <NSObject>

- (void)didTapProduct:(UserProduct*)userProduct parentObject:(id)parentObject;
- (void)didTapSales:(UserProduct*)userProduct parentObject:(id)parentObject;

@end
