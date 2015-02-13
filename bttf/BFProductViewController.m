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
#import "User.h"

static NSString *const ProductCellIdentifier = @"ProductCell";
static NSString *const AddItemCellIdentifier = @"AddItemCell";

@interface BFProductViewController () <UITableViewDelegate, UITableViewDataSource>


@end

@implementation BFProductViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.navigationItem.title = @"Your Products";
    self.tableView.backgroundColor = [UIColor darkGrayColor];
    self.view.backgroundColor = [UIColor darkGrayColor];

    
    [self loadData];
}

#pragma mark - Data
- (void) loadData {
    
    
    NSDictionary* parameters;
    if (self.parentObject) {
    
        CategoryProduct* categoryProduct = (CategoryProduct*)self.parentObject;
        parameters = @{ @"category_product" : categoryProduct.objectId,
                        @"user_id" : [User sharedInstance].objectId
                        };
    }
    __weak __typeof(self) weakSelf = self;
    [[BFClientAPI sharedAPI] getUserProductsWithParameters:parameters withSuccess:^(NSArray *categories) {
        
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        
        strongSelf.objects = categories;
        [strongSelf objectsDidLoad];
        
    } failure:^(NSError *error) {
        
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
        
        return cell;
    }
    
    BFProductTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:ProductCellIdentifier
                                                                         forIndexPath:indexPath];
    
    CategoryMain* category = self.objects[indexPath.row];
    
    cell.backgroundColor = [UIColor clearColor];
    
    cell.textLabel.text = category.name;
    cell.detailTextLabel.text = @"1";
    
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
    


}

@end
