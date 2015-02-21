//
//  BFCategoryViewController.h
//  bttf
//
//  Created by Admin on 2/10/15.
//  Copyright (c) 2015 bttf. All rights reserved.
//

#import "BFBaseViewController.h"


@protocol BFCategoryVCDelegate;

@interface BFCategoryViewController : BFBaseViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, assign) NSInteger categoryIndex;

@property (nonatomic, strong) NSArray* objects;

@property (nonatomic, strong) id parentObject;

@property (nonatomic, weak) id<BFCategoryVCDelegate> delegate;

- (void)reloadData;

@end


@protocol BFCategoryVCDelegate <NSObject>

- (void)didTapCellWithObject:(id)parentObject tableViewIndex:(NSInteger)tableViewIndex;

@end
