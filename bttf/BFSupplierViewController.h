//
//  BFSupplierViewController.h
//  bttf
//
//  Created by Admin on 2/20/15.
//  Copyright (c) 2015 bttf. All rights reserved.
//

#import "BFBaseViewController.h"

@protocol BFSupplierVCDelegate;

@interface BFSupplierViewController : BFBaseViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray* objects;

@property (nonatomic, strong) id parentObject;

@property (nonatomic, weak) id<BFSupplierVCDelegate> delegate;

- (void)reloadData;


@end



@protocol BFSupplierVCDelegate <NSObject>

- (void)didTapCellWithObject:(id)parentObject;

@end
