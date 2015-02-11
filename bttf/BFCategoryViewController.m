//
//  BFCategoryViewController.m
//  bttf
//
//  Created by Admin on 2/10/15.
//  Copyright (c) 2015 bttf. All rights reserved.
//

#import "BFCategoryViewController.h"
#import "BFCategoryTableViewCell.h"
#import "CategoryMain.h"
#import "BFClientAPI.h"

static NSString *const CategoryCellIdentifier = @"CategoryCell";


@interface BFCategoryViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation BFCategoryViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Select Category";

    self.tableView.backgroundColor = [UIColor whiteColor];
    if (self.categoryIndex == 1) self.tableView.backgroundColor = [UIColor blueColor];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self loadData];
}

#pragma mark - Data
- (void) loadData {
    
    NSLog(@"self.categoryIndex = %ld",(long)self.categoryIndex);
    
    __weak __typeof(self) weakSelf = self;
    NSDictionary* parameters = @{ @"level" : @(self.categoryIndex) };
    [[BFClientAPI sharedAPI] getCategoryWithParameters:parameters withSuccess:^(NSArray *categories) {
        
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
    BFCategoryTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CategoryCellIdentifier
                                                            forIndexPath:indexPath];

    CategoryMain* category = self.objects[indexPath.row];
    
    cell.contentView.backgroundColor = [UIColor redColor];
    if (self.categoryIndex == 1) cell.contentView.backgroundColor = [UIColor blueColor];

    cell.textLabel.text = category.name;
    cell.detailTextLabel.text = @"1";

    return cell;
}



#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTapCellAtIndex:tableViewIndex:)]) {
        [self.delegate didTapCellAtIndex:indexPath.row tableViewIndex:self.categoryIndex];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
