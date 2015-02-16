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
#import "CategoryProduct.h"
#import "BFClientAPI.h"
#import "BFConstants.h"

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


- (NSArray*) objects {
    if (!_objects) {
        _objects = [NSArray new];
    }
    return _objects;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Nav Title
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 1;
    label.font = [UIFont boldSystemFontOfSize:20.0f];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    switch (self.categoryIndex) {
        case 0:
            label.text = @"Select Main Category";
            break;
            
        case 1:
            label.text = @"Select Sub Category";
            break;
            
        case 2:
            label.text = @"Select Product Category";
            break;
            
        default:
            break;
    }
    [label sizeToFit];
    self.navigationItem.titleView = label;
    
    // BG Color
    switch (self.categoryIndex) {
        case 0:
        {
            self.tableView.backgroundColor = [UIColor whiteColor];
            self.view.backgroundColor = [UIColor whiteColor];
        }
            break;
            
        case 1:
        {
            self.tableView.backgroundColor = [UIColor lightGrayColor];
            self.view.backgroundColor = [UIColor lightGrayColor];
        }

            break;
            
        case 2:
        {
            self.tableView.backgroundColor = [UIColor grayColor];
            self.view.backgroundColor = [UIColor grayColor];
        }
            break;
            
        default:
            break;
    }
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.activityView.center = self.tableView.center;
    
    // This will remove extra separators from tableview
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self loadData];
}

- (void) viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
}


-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    // This is a hack to get the tableView clear of the navBar -- Due to drillDownController
    self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
}

#pragma mark - Data
- (void) loadData {
    
    [self animateActivityIndicatorAndSetTimer];
    
    __weak __typeof(self) weakSelf = self;
    
    switch (self.categoryIndex) {
        case BFCategoryMain:
        {
            
            [[BFClientAPI sharedAPI] getCategoriesMainWithParameters:nil withSuccess:^(NSArray *categories) {
                
                [self stopActivityIndicatorAndTimer];
                
                __strong __typeof(weakSelf) strongSelf = weakSelf;
                
                strongSelf.objects = categories;
                [strongSelf objectsDidLoad];
                
            } failure:^(NSError *error) {
                [self stopActivityIndicatorAndTimer];
                NSLog(@"error = %@",error);
                
            }];
        }
            break;
            
        case BFCategorySub:
        {
            NSDictionary* parameters;
            if (self.parentObject) {
                CategoryMain* categoryMain = (CategoryMain*)self.parentObject;
                parameters = @{ [CategorySub categoryMainIdKey] : categoryMain.objectId };
            }
           
            [[BFClientAPI sharedAPI] getCategoriesSubWithParameters:parameters withSuccess:^(NSArray *categories) {
                [self stopActivityIndicatorAndTimer];

                __strong __typeof(weakSelf) strongSelf = weakSelf;
                
                strongSelf.objects = categories;
                [strongSelf objectsDidLoad];
                
            } failure:^(NSError *error) {
                [self stopActivityIndicatorAndTimer];
                NSLog(@"error = %@",error);
                
            }];
        }
            break;
            
        case BFCategoryProduct:
        {
            NSDictionary* parameters;
            if (self.parentObject) {
                CategorySub* categorySub = (CategorySub*)self.parentObject;
                parameters = @{ [CategoryProduct categorySubIdKey] : categorySub.objectId };
            }

            [[BFClientAPI sharedAPI] getCategoriesProductWithParameters:parameters withSuccess:^(NSArray *categories) {
                [self stopActivityIndicatorAndTimer];

                __strong __typeof(weakSelf) strongSelf = weakSelf;
                
                strongSelf.objects = categories;
                [strongSelf objectsDidLoad];
                
            } failure:^(NSError *error) {
                [self stopActivityIndicatorAndTimer];

                NSLog(@"error = %@",error);
                
            }];
        }
            break;
            
        default:
            break;
    }
    
    
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
    BFCategoryTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CategoryCellIdentifier
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
    id parentObject = self.objects[indexPath.row];
    NSAssert(parentObject,@"No parentObject at indexPath.row");
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTapCellWithObject:tableViewIndex:)]) {
        [self.delegate didTapCellWithObject:parentObject tableViewIndex:self.categoryIndex];
    }
}

/*
#pragma mark - Navigation

 In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     Get the new view controller using [segue destinationViewController].
     Pass the selected object to the new view controller.
}
*/


@end
