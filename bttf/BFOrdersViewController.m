//
//  BFOrdersViewController.m
//  bttf
//
//  Created by Admin on 2/20/15.
//  Copyright (c) 2015 bttf. All rights reserved.
//

#import "BFOrdersViewController.h"
#import "BFOrderTableViewCell.h"
#import "BFSubmitTableViewCell.h"
#import "UIColor+Extensions.h"
#import "UserProduct.h"
#import "BFClientAPI.h"

static NSString *const OrderCellIdentifier = @"OrderCell";
static NSString *const OrderHeaderCellIdentifier = @"OrdersHeaderCell";
static NSString *const SubmitCellIdentifier = @"SubmitCell";


@interface BFOrdersViewController () <UITableViewDataSource, UITableViewDelegate, BFOrderTableViewCellDelegate>


@property (nonatomic, strong) NSMutableDictionary* batchCounts;

@end

@implementation BFOrdersViewController

- (NSMutableDictionary*) batchCounts {
    if (!_batchCounts) {
        _batchCounts = [NSMutableDictionary new];
    }
    return _batchCounts;
}

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
    
    // Add a string objects to self.objects to account for HeaderCell && SubmitCell
    NSMutableArray* mutableObjects = [self.objects mutableCopy];
    [mutableObjects insertObject:@"headerCell" atIndex:0];
    [mutableObjects addObject:@"submitCell"];
    self.objects = [mutableObjects copy];

    
    [self.tableView reloadData];
}

- (void)increaseBatchCountTracker:(NSNumber*)indexKey increment:(NSInteger)increment{
    
    if (self.batchCounts[indexKey]) {
        NSNumber* batchCountOriginal = self.batchCounts[indexKey];
        NSNumber* batchCountNew = @([batchCountOriginal integerValue] + increment);
        self.batchCounts[indexKey] = batchCountNew;
    }
    else {
        self.batchCounts[indexKey] = @(increment);
    }
}

- (void)resetBatchCountTracker {
    
    NSArray* keys = [self.batchCounts allKeys];
    [keys enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        self.batchCounts[obj] = @(0);
    }];
       
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Header Cell
    if (indexPath.row == 0 &&
        [self.objects[0] isKindOfClass:[NSString class]] &&
        [self.objects[0] isEqualToString:@"headerCell"]) {
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:OrderHeaderCellIdentifier
                                                                     forIndexPath:indexPath];
        cell.backgroundColor = [UIColor clearColor];
        cell.userInteractionEnabled = NO;
        return cell;
    }
    
    // Footer Cell
    if (indexPath.row == self.objects.count - 1 &&
        [self.objects.lastObject isKindOfClass:[NSString class]] &&
        [self.objects.lastObject isEqualToString:@"submitCell"]) {
        BFSubmitTableViewCell *cell = (BFSubmitTableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:SubmitCellIdentifier
                                                                     forIndexPath:indexPath];
        cell.backgroundColor = [UIColor clearColor];
        
        // Enable?
        BOOL shouldEnableSubmitCell = [self shouldEnableSubmitCell];
        [cell setEnabled:shouldEnableSubmitCell animated:NO];
        
        return cell;
    }
    
    
    // Order Cell
    BFOrderTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:OrderCellIdentifier
                                                                 forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.tag = indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;

    
    // Populate
    if (self.objects.count < indexPath.row) return cell;
    
    UserProduct* userProduct = [self.objects objectAtIndex:indexPath.row];
    cell.nameLabel.text = userProduct.name;
    cell.quantityBatchSizeLabel.text = [userProduct.quantityPerCase stringValue];
    cell.quantityUnitsTotalLabel.text = [userProduct.quantityUnits stringValue];
    
    // batchCount
    NSNumber* batchCount = @(0);
    if (self.batchCounts[@(indexPath.row)]) batchCount = self.batchCounts[@(indexPath.row)];
    cell.quantityBatchesLabel.text = [batchCount stringValue];

    // orderStatus
    [cell setOrderStatus:[userProduct orderStatus]];
            
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Is this a submitCell row?
    if (indexPath.row == self.objects.count - 1 &&
        [self.objects.lastObject isEqualToString:@"submitCell"]) {
        
        // Submit
        [self resetBatchCountTracker];
        [self.tableView reloadData];

        // Show alert
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Submitted", @"Submitted")
                                                          message:[NSString stringWithFormat:@"Your orders have been saved"]
                                                         delegate:nil
                                                cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                                otherButtonTitles:nil];
        [message show];
    }
}


#pragma mark - BFOrdersViewController
- (BOOL)shouldEnableSubmitCell {
    
    __block NSInteger batchCountTotal = 0;
    
    // Add all the batch counts
    [self.batchCounts enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        
        NSNumber* batchCount = (NSNumber*)obj;
        batchCountTotal += [batchCount integerValue];
    }];
    

    if (batchCountTotal > 0) return YES;
    return NO;
    
}

- (void)enableSubmitCell:(BOOL)showSubmitCell {
    
    // Get cell
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:(self.objects.count - 1) inSection:0];
    BFSubmitTableViewCell* submitCell = (BFSubmitTableViewCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    if (![submitCell.reuseIdentifier isEqualToString:SubmitCellIdentifier]) return;
    
    
    // setEnabled
    [submitCell setEnabled:showSubmitCell animated:YES];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
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
        
        // Update batchCounts
        [self increaseBatchCountTracker:@(orderCell.tag) increment:1];
        
        // Reload row && submit row
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:orderCell.tag inSection:0];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        // enable submit?
        BOOL shouldEnableSubmitCell = [self shouldEnableSubmitCell];
        [self enableSubmitCell:shouldEnableSubmitCell];

        
        // Update in DB
        [[BFClientAPI sharedAPI] updateUserProduct:userProduct withSuccess:nil failure:^(NSError *error) {
            [self hasErrorWithLocalizedDescription:@"Unable to update Product"];
            
            // Set back to original
            [userProduct updateBatches:-1];
            
            [self increaseBatchCountTracker:@(orderCell.tag) increment:-1];
            
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            // enable submit?
            BOOL shouldEnableSubmitCell = [self shouldEnableSubmitCell];
            [self enableSubmitCell:shouldEnableSubmitCell];

        }];

    }
    
}

-(void)didTapDecreaseBatchesButton:(UITableViewCell*)orderCell {
    
    UserProduct* userProduct = [self.objects objectAtIndex:orderCell.tag];
    if ([userProduct updateBatches:-1]) {
        
        // Update batchCounts
        [self increaseBatchCountTracker:@(orderCell.tag) increment:-1];
        
        // Reload Row
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:orderCell.tag inSection:0];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        // enable submit?
        BOOL shouldEnableSubmitCell = [self shouldEnableSubmitCell];
        [self enableSubmitCell:shouldEnableSubmitCell];
        
        // Update in DB
        [[BFClientAPI sharedAPI] updateUserProduct:userProduct withSuccess:nil failure:^(NSError *error) {
            [self hasErrorWithLocalizedDescription:@"Unable to update Product"];
            
            // Set back to original
            [userProduct updateBatches:1];
            
            [self increaseBatchCountTracker:@(orderCell.tag) increment:1];
            
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            // enable submit?
            BOOL shouldEnableSubmitCell = [self shouldEnableSubmitCell];
            [self enableSubmitCell:shouldEnableSubmitCell];
        }];

    }
}



@end
