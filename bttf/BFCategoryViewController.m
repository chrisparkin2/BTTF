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
#import "UIColor+Extensions.h"

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
        case BFCategoryMain:
            label.text = @"Select Main Category";
            break;
            
        case BFCategorySub:
            label.text = @"Select Sub Category";
            break;
            
        case BFCategoryProduct:
            label.text = @"Select Product Category";
            break;
            
        default:
            break;
    }
    [label sizeToFit];
    self.navigationItem.titleView = label;
    
    // BG Color
    switch (self.categoryIndex) {
        case BFCategoryMain:
        {
            self.tableView.backgroundColor = [UIColor colorFog];
            self.view.backgroundColor = [UIColor colorFog];
        }
            break;
            
        case BFCategorySub:
        {
            self.tableView.backgroundColor = [UIColor lightGrayColor];
            self.view.backgroundColor = [UIColor lightGrayColor];
        }

            break;
            
        case BFCategoryProduct:
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
    
    // This is to get the tableView clear of the navBar -- Due to drillDownController
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
            if (!self.parentObject) {
                [self hasErrorWithLocalizedDescription:@"Something went wrong. Please go back and try again"];
                return;
            }
            
            CategoryMain* categoryMain = (CategoryMain*)self.parentObject;
            parameters = @{ [CategorySub categoryMainIdKey] : categoryMain.objectId };

           
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
            if (!self.parentObject) {
                [self hasErrorWithLocalizedDescription:@"Something went wrong. Please go back and try again"];
                return;
            }
            
            CategorySub* categorySub = (CategorySub*)self.parentObject;
            parameters = @{ [CategoryProduct categorySubIdKey] : categorySub.objectId };

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
    
    // Handle special whole animal cell -- highlight
    if (self.categoryIndex == BFCategorySub &&
        [category.name isEqualToString:@"Whole Animals"] ) {
        cell.backgroundColor = [UIColor colorSalmon];
    }
    
    cell.textLabel.text = category.name;

    return cell;
}



#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id newParentObject = self.objects[indexPath.row];
    NSAssert(newParentObject,@"No parentObject at indexPath.row");
    
    // Handle special Whole Animal case -- Present whole animal screen
    // NOTE: Hack to insert previous dev's work on Whole Animal flow
    if (self.categoryIndex == BFCategorySub) {
        
        CategorySub* categorySub = (CategorySub*)newParentObject;
        if ([categorySub.name isEqualToString:@"Whole Animals"]) {
            
            [self hasErrorWithLocalizedDescription:@"Please use the B2TF - Butcher app for Whole Animal processing"];
            
            // FIXME: Integration of previous dev's work not working
//            if (self.delegate && [self.delegate respondsToSelector:@selector(didTapCellForWholeAnimal)]) {
//                [self.delegate didTapCellForWholeAnimal];
//            }
            
            return;
        }
    }
    
    // Delegate
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTapCellWithObject:tableViewIndex:)]) {
        [self.delegate didTapCellWithObject:newParentObject tableViewIndex:self.categoryIndex];
    }
}



@end
