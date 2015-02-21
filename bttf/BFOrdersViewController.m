//
//  BFOrdersViewController.m
//  bttf
//
//  Created by Admin on 2/20/15.
//  Copyright (c) 2015 bttf. All rights reserved.
//

#import "BFOrdersViewController.h"
#import "BFOrderTableViewCell.h"
#import "UIColor+Extensions.h"
#import "UserProduct.h"
#import "BFClientAPI.h"

static NSString *const OrderCellIdentifier = @"OrderCell";
static NSString *const OrderHeaderCellIdentifier = @"OrdersHeaderCell";


@interface BFOrdersViewController () <UITableViewDataSource, UITableViewDelegate, BFOrderTableViewCellDelegate>


@end

@implementation BFOrdersViewController

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
    label.text = @"Orders";
    [label sizeToFit];
    self.navigationItem.titleView = label;
    
    // BG Color
    self.tableView.backgroundColor = [UIColor colorSalmon];
    self.view.backgroundColor = [UIColor colorSalmon];
    
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.activityView.center = self.tableView.center;
    
    // This will remove extra separators from tableview
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.tableView.allowsSelection = NO;
    
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
    
    NSDictionary* parameters;
    NSString* supplier = (NSString*)self.parentObject;
    parameters = @{ [UserProduct supplierKey] : supplier };
    
    
    [[BFClientAPI sharedAPI] getUserProductsWithParameters:parameters withSuccess:^(NSArray *objects) {
        
        [self stopActivityIndicatorAndTimer];
        
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        
        strongSelf.objects = objects;
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
    
    // Add an NSNull object to self.objects to account for HeaderCell
    NSMutableArray* mutableObjects = [self.objects mutableCopy];
    [mutableObjects insertObject:[NSNull null] atIndex:0];
    self.objects = [mutableObjects copy];
    
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Header Cell
    if (indexPath.row == 0) {
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:OrderHeaderCellIdentifier
                                                                     forIndexPath:indexPath];
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }
    
    
    // Order Cell
    BFOrderTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:OrderCellIdentifier
                                                                 forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.tag = indexPath.row;
    cell.delegate = self;

    
    // Data
    if (self.objects.count < indexPath.row) return cell;
    
    UserProduct* userProduct = [self.objects objectAtIndex:indexPath.row];
    cell.nameLabel.text = userProduct.name;
    cell.quantityBatchesLabel.text = [userProduct.quantityBulk stringValue];
    cell.quantityBatchSizeLabel.text = [userProduct.quantityPerCase stringValue];
    cell.quantityUnitsTotalLabel.text = [userProduct.quantityUnits stringValue];
    
    [cell setOrderStatus:[userProduct orderStatus]];
            
    return cell;
}



#pragma mark - BFOrderTableViewCell Delegate
- (void)didTapEditButton:(UITableViewCell*)orderCell {
    // A Product Cell
    UserProduct* userProduct = self.objects[orderCell.tag];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTapProduct:parentObject:)]) {
        [self.delegate didTapProduct:userProduct parentObject:self.parentObject];
    }
}
- (void)didTapIncreaseBatchesButton:(UITableViewCell*)orderCell {
    
    UserProduct* userProduct = [self.objects objectAtIndex:orderCell.tag];
    if ([userProduct updateBatches:1]) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:orderCell.tag inSection:0];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        // Update in DB
        [[BFClientAPI sharedAPI] updateUserProduct:userProduct withSuccess:nil failure:^(NSError *error) {
            [self hasErrorWithLocalizedDescription:@"Unable to update Product"];
            
            // Set back to original
            [userProduct updateBatches:-1];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];

        }];

    }
    
}

-(void)didTapDecreaseBatchesButton:(UITableViewCell*)orderCell {
    
    UserProduct* userProduct = [self.objects objectAtIndex:orderCell.tag];
    if ([userProduct updateBatches:-1]) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:orderCell.tag inSection:0];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        // Update in DB
        [[BFClientAPI sharedAPI] updateUserProduct:userProduct withSuccess:nil failure:^(NSError *error) {
            [self hasErrorWithLocalizedDescription:@"Unable to update Product"];
            
            // Set back to original
            [userProduct updateBatches:1];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];            
        }];

    }
}



@end
