//
//  BFSupplierViewController.m
//  bttf
//
//  Created by Admin on 2/20/15.
//  Copyright (c) 2015 bttf. All rights reserved.
//

#import "BFSupplierViewController.h"
#import "UIColor+Extensions.h"
#import "BFClientAPI.h"
#import "BFSupplierTableViewCell.h"

static NSString *const SupplierCellIdentifier = @"SupplierCell";


@interface BFSupplierViewController () <UITableViewDataSource, UITableViewDelegate>


@end

@implementation BFSupplierViewController 

- (NSArray*) objects {
    if (!_objects) {
        _objects = [NSArray new];
    }
    return _objects;
}

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Nav Title
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 1;
    label.font = [UIFont boldSystemFontOfSize:20.0f];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.text = @"Select Supplier";
    [label sizeToFit];
    self.navigationItem.titleView = label;
    
    // BG Color
    self.tableView.backgroundColor = [UIColor colorFog];
    self.view.backgroundColor = [UIColor colorFog];

    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.activityView.center = self.tableView.center;
    
    // This will remove extra separators from tableview
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self loadData];


}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    // This is to get the tableView clear of the navBar -- Due to drillDownController
    self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
}


#pragma mark - Data
- (void) loadData {
    
    [self animateActivityIndicatorAndSetTimer];
    
    __weak __typeof(self) weakSelf = self;
    
    [[BFClientAPI sharedAPI] getSuppliersWithParameters:nil withSuccess:^(NSArray *categories) {
        
        [self stopActivityIndicatorAndTimer];
        
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        
        strongSelf.objects = categories;
        [strongSelf objectsDidLoad];
        
    } failure:^(NSError *error) {
        [self stopActivityIndicatorAndTimer];
        NSLog(@"error = %@",error);
        
    }];
}

- (void)reloadData {
    [self loadData];
}

- (void)objectsDidLoad {
    [self.tableView reloadData];
}



#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BFSupplierTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:SupplierCellIdentifier
                                                                         forIndexPath:indexPath];
    
    
    NSString* supplier = self.objects[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    
    cell.supplierLabel.text = supplier;
    cell.countLabel.text = [@([UserProduct countUserProductsForSupplier:supplier]) stringValue];
        
    return cell;
}



#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id newParentObject = self.objects[indexPath.row];
    NSAssert(newParentObject,@"No parentObject at indexPath.row");
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTapCellWithObject:)]) {
        [self.delegate didTapCellWithObject:newParentObject];
    }
}

@end
