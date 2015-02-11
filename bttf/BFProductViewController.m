//
//  BFProductViewController.m
//  bttf
//
//  Created by Admin on 2/11/15.
//  Copyright (c) 2015 bttf. All rights reserved.
//

#import "BFProductViewController.h"
#import "BFProductTableViewCell.h"
#import "BFClientAPI.h"

static NSString *const ProductCellIdentifier = @"ProductCell";

@interface BFProductViewController () <UITableViewDelegate, UITableViewDataSource>


@end

@implementation BFProductViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self loadData];
}

#pragma mark - Data
- (void) loadData {
    
    __weak __typeof(self) weakSelf = self;
    NSDictionary* parameters = @{  };
    [[BFClientAPI sharedAPI] getProductsWithParameters:parameters withSuccess:^(NSArray *categories) {
        
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
    return self.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BFProductTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:ProductCellIdentifier
                                                                         forIndexPath:indexPath];
    
    CategoryMain* category = self.objects[indexPath.row];
    
    cell.contentView.backgroundColor = [UIColor redColor];
    
    cell.textLabel.text = category.name;
    cell.detailTextLabel.text = @"1";
    
    return cell;
}



#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

@end
