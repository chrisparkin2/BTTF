//
//  BFProductViewController.h
//  bttf
//
//  Created by Admin on 2/11/15.
//  Copyright (c) 2015 bttf. All rights reserved.
//

#import "BFBaseViewController.h"

@interface BFProductViewController : BFBaseViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray* objects;

@property (nonatomic, strong) id parentObject;


@end
