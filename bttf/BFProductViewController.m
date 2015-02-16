//
//  BFProductViewController.m
//  bttf
//
//  Created by Admin on 2/11/15.
//  Copyright (c) 2015 bttf. All rights reserved.
//

#import "BFProductViewController.h"
#import "BFProductTableViewCell.h"
#import "BFAddItemTableViewCell.h"
#import "BFClientAPI.h"
#import "CategoryProduct.h"
#import "UserProduct.h"
#import "User.h"
#import "BFConstants.h"
#import "UIColor+Extensions.h"

static NSString *const ProductCellIdentifier = @"ProductCell";
static NSString *const AddItemCellIdentifier = @"AddItemCell";

@interface BFProductViewController () <UITableViewDelegate, UITableViewDataSource>


@end

@implementation BFProductViewController


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kBFNotificationCenterDidUpdateUserProductKey object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Your Products";
    self.view.backgroundColor = self.tableView.backgroundColor;
    
    self.activityView.center = self.tableView.center;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.backgroundColor = [UIColor colorMustard];
    self.view.backgroundColor = [UIColor colorMustard];
    
    // This will remove extra separators from tableview
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero]; 

    
    [self loadData];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self registerForNotifications];
}

#pragma mark - Data
- (void) loadData {
    
    [self animateActivityIndicatorAndSetTimer];
    
    NSDictionary* parameters;
    if (self.parentObject) {
    
        CategoryProduct* categoryProduct = (CategoryProduct*)self.parentObject;
        parameters = @{ @"categoryProduct" : categoryProduct.objectId,
                        @"userId" : [User sharedInstance].objectId
                        };
    }
    __weak __typeof(self) weakSelf = self;
    [[BFClientAPI sharedAPI] getUserProductsWithParameters:parameters withSuccess:^(NSArray *categories) {
        [self stopActivityIndicatorAndTimer];

        __strong __typeof(weakSelf) strongSelf = weakSelf;
        
        strongSelf.objects = categories;
        [strongSelf objectsDidLoad];
        
    } failure:^(NSError *error) {
        [self stopActivityIndicatorAndTimer];
        NSLog(@"error = %@",error);
    }];
    
}

- (void)objectsDidLoad {
    
    [self.tableView reloadData];
    
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.objects.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // Add Product Cell
    if (indexPath.row == self.objects.count) {
        BFAddItemTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:AddItemCellIdentifier
                                                                            forIndexPath:indexPath];
        
        cell.backgroundColor = [UIColor clearColor];
        
        return cell;
    }
    
    BFProductTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:ProductCellIdentifier
                                                                         forIndexPath:indexPath];
    
    UserProduct* userProduct = self.objects[indexPath.row];
    
    cell.backgroundColor = [UIColor clearColor];
    
    cell.textLabel.text = userProduct.name;
    cell.detailTextLabel.text = [userProduct.quantityUnits stringValue];
    
    return cell;
}



#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Add Product Cell
    if (indexPath.row == self.objects.count) {
        
        NSAssert(self.parentObject,@"No parentObject");
               
        if (self.productDelegate && [self.productDelegate respondsToSelector:@selector(didTapAddNewProduct:)]) {
            [self.productDelegate didTapAddNewProduct:self.parentObject];
        }
        
        return;
    }
    
    // A Product Cell
    UserProduct* userProduct = self.objects[indexPath.row];
    
    if (self.productDelegate && [self.productDelegate respondsToSelector:@selector(didTapProduct:parentObject:)]) {
        [self.productDelegate didTapProduct:userProduct parentObject:self.parentObject];
    }

}

#pragma mark - NSNotificationCenter
- (void) registerForNotifications {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kBFNotificationCenterDidUpdateUserProductKey object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didUpdateUserProduct:) name:kBFNotificationCenterDidUpdateUserProductKey object:nil];
    
}

- (void)didUpdateUserProduct:(NSNotification*)notification {
    
    NSDictionary *dict = [notification userInfo];
    UserProduct* userProduct = [dict objectForKey:kBFNotificationInfoUserProductKey];
    NSMutableArray* mutableObjects = [self.objects mutableCopy];
    
    // First check if this userProduct exists
    __block BOOL foundObject = NO;
    [self.objects enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UserProduct* userProductToCheck = (UserProduct*)obj;
        if ([userProduct.objectId isEqualToString:userProductToCheck.objectId]) {
            [mutableObjects replaceObjectAtIndex:idx withObject:userProduct];
            foundObject = YES;
            *stop = YES;
            return;
        }
    }];
    if (foundObject) {
        self.objects = [mutableObjects copy];
        return;
    }
    
    
    // If not, then add
    [mutableObjects addObject:userProduct];
    self.objects = [mutableObjects copy];
    
    [self.tableView reloadData];
}

@end
