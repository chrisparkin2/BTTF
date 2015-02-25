//
//  InfoScreen.m
//  BackToTheFarm
//
//  Created by Siddhant Dange on 11/27/14.
//  Copyright (c) 2014 Siddhant Dange. All rights reserved.
//

#import "InfoScreen.h"
#import "InfoViewSubcutCell.h"
#import "AppDelegate.h"
#import "User.h"
#import "PopupView.h"


@interface InfoScreen ()

@property (weak, nonatomic) IBOutlet UILabel *meatYieldLabel;
@property (weak, nonatomic) IBOutlet UILabel *trimYieldLabel;
@property (weak, nonatomic) IBOutlet UILabel *dogFoodYieldLabel;
@property (weak, nonatomic) IBOutlet UILabel *wasteYieldLabel;
@property (weak, nonatomic) IBOutlet UILabel *waterLossLabel;
@property (weak, nonatomic) IBOutlet UITableView *stockTableView;
@property (weak, nonatomic) IBOutlet UILabel *generalCutNameLabel;

@property (nonatomic, strong) NSMutableDictionary *subcutMeats, *subcutPercs;
@property (nonatomic, strong) NSMutableDictionary *categoryTotal, *subcutTotal;
@property (nonatomic, strong) NSMutableArray *categoryNameArr, *subcutNameArr;
@property (nonatomic, strong) NSString *generalCutName;
@property (nonatomic, assign) int totalWeight;


@end

@implementation InfoScreen


-(void)setup{
    
    _subcutMeats = ((NSDictionary*)self.passedData[@"meat_data"]).mutableCopy;
    _subcutPercs = ((NSDictionary*)self.passedData[@"perc_data"]).mutableCopy;
    _generalCutName = self.passedData[@"general_cut_name"];
    [_generalCutNameLabel setText:_generalCutName];
    _subcutNameArr = _subcutMeats.allKeys.mutableCopy;
    
    //calculate totals for category
    _categoryTotal = @{
                       @"Meat" : @(0),
                       @"Trim" : @(0),
                       @"Dogfood" : @(0),
                       @"Bones" : @(0),
                       @"Waste" : @(0),
                       }.mutableCopy;
    _categoryNameArr = _categoryTotal.allKeys.mutableCopy;
    float totalWeight = [self generateTotal:_subcutPercs withCategories:@[@"Meat"]];
    [self calcTotalsFromWeightsRec:_subcutPercs fromCategories:_categoryTotal];
    
    for(NSString *key in _categoryTotal.allKeys){
        float total = ((NSNumber*)_categoryTotal[key]).floatValue;
        total /= totalWeight;
        total *= 100;
        [_categoryTotal setObject:@(total) forKey:key];
    }
    
    //calculate totals for each subcut
    _subcutTotal = @{}.mutableCopy;
    for(NSString *key in _subcutMeats.allKeys){
        float total = [self generateTotal:_subcutMeats[key] withCategories:_categoryTotal.allKeys];
        [_subcutTotal setObject:@(total) forKey:key];
    }
    
    
    //set fields
    [_meatYieldLabel setText:[NSString stringWithFormat:@"%0.0f%%", ((NSNumber*)_categoryTotal[@"Meat"]).floatValue]];
    [_trimYieldLabel setText:[NSString stringWithFormat:@"%0.0f%%", ((NSNumber*)_categoryTotal[@"Trim"]).floatValue]];
    [_dogFoodYieldLabel setText:[NSString stringWithFormat:@"%0.0f%%", ((NSNumber*)_categoryTotal[@"Dogfood"]).floatValue]];
    [_wasteYieldLabel setText:[NSString stringWithFormat:@"%0.0f%%", ((NSNumber*)_categoryTotal[@"Waste"]).floatValue]];
    [_waterLossLabel setText:[NSString stringWithFormat:@"%0.0f%%", ((NSNumber*)_categoryTotal[@"Bones"]).floatValue]];
    
    _stockTableView.dataSource = self;
    _stockTableView.delegate = self;
    
    [_stockTableView registerNib:[UINib nibWithNibName:@"InfoViewSubcutCell" bundle:nil] forCellReuseIdentifier:@"InfoViewSubcutCell"];
    
    [_stockTableView reloadData];
}

-(void)calcTotalsFromWeightsRec:(NSDictionary*)weights fromCategories:(NSMutableDictionary*)categories{
    for(NSString *key in weights){
        if([categories.allKeys containsObject:key]){
            float total = ((NSNumber*)categories[key]).floatValue;
            total += ((NSNumber*)weights[key]).floatValue;
            [categories setValue:@(total) forKey:key];
        } else{
            [self calcTotalsFromWeightsRec:weights[key] fromCategories:categories];
        }
    }
}

-(NSMutableDictionary*)calcTotalSubs:(NSDictionary*)subs categories:(NSMutableDictionary*)categories{
    
    //if at lowest levels
    if([subs objectForKey:@"Meat"]){
        for(NSString *category in categories.allKeys){
            float total = ((NSNumber*)categories[category]).floatValue;
            float val = ((NSNumber*)subs[category]).floatValue;
            
            total += val;
            [categories setObject:@(total) forKey:category];
        }
        
        return categories;
    }
    
    //else go down for each subcategory
    for(NSString *subcategory in subs.allKeys){
        [self calcTotalSubs:subs[subcategory] categories:categories];
    }
    
    
    return categories;
}


- (IBAction)backAction:(id)sender {
    [self popScreenWithAnimation:YES];
}
- (IBAction)settingsAction:(id)sender {
    
    User *user = [User sharedInstance];
    PopupView *pv = [[PopupView alloc] initWithScreen:@"AdjustYieldTestScreen" andData:@{@"general_cut_name" : @"general", @"subcuts_weights" : _subcutMeats,  @"subcuts_percs" : _subcutPercs, @"first_yeild_test_mode" : @(!user.firstYieldTestComplete)} onScreen:self];
    [self.view addSubview:pv];
    pv.delegate = self;
    pv.closeAction = @selector(settingsClosed);
    
}

-(void)settingsClosed{
    User *user = [User sharedInstance];
    [user syncMeatWeightSuccess:^{
        [self setup];
    } failure:nil];
    [self setup];
}


#pragma -mark UITableViewDataSource Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    int numRows = (int)_subcutNameArr.count;
    return numRows;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // Identifier for retrieving reusable cells.
    static NSString *cellIdentifier = @"InfoViewSubcutCell";
    
    // Attempt to request the reusable cell.
    InfoViewSubcutCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    // No cell available - create one.
    if(cell == nil) {
        cell = [[InfoViewSubcutCell alloc] init];
    }
    
    int row = (int)indexPath.row;
    NSString *subcutName = _subcutNameArr[row];
    [cell.subcutNameLabel setText:subcutName];
    [cell.subcutPercLabel setText:[NSString stringWithFormat:@"%0.0f lbs.", ((NSNumber*)_subcutTotal[subcutName]).floatValue]];
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}
#pragma -mark UITableViewDelegate Methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *subcutName = _subcutNameArr[indexPath.row];
    if(![((NSDictionary*)_subcutMeats[subcutName]).allKeys containsObject:@"Meat"]){
        [self goToScreen:@"InfoScreen" animated:YES withData:@{@"meat_data" : _subcutMeats[subcutName], @"perc_data" : _subcutPercs[subcutName], @"general_cut_name" : subcutName}];
    }
 }

#pragma -mark Meat Conversion Methods

-(float)generateTotal:(NSDictionary*)meats withCategories:(NSArray*)categories{
    float total = 0.0f;
    
    if([meats objectForKey:@"Meat"]){
        
        for(NSString *key in categories){
            total += ((NSNumber*)meats[key]).floatValue;
        }
        
        return total;
    }
    
    for(NSString* key in meats){
        total += [self generateTotal:meats[key] withCategories:_categoryNameArr];
    }
    
    return total;
}

-(NSMutableDictionary*)generatePercData:(NSMutableDictionary*)meats{
    float totalWeight = [self generateTotal:meats withCategories:_categoryNameArr];
    NSMutableDictionary *percData = (NSMutableDictionary*)CFBridgingRelease(CFPropertyListCreateDeepCopy(kCFAllocatorDefault, (CFPropertyListRef)meats, kCFPropertyListMutableContainers));
    [self meatsToPerc:percData withTotalWeight:totalWeight];
    return percData;
}


-(void)meatsToPerc:(NSMutableDictionary*)meats withTotalWeight:(float)totalWeight{
    for(NSString *key in meats.allKeys){
        if([meats[key] isKindOfClass:[NSDictionary class]]){
            [self meatsToPerc:meats[key] withTotalWeight:totalWeight];
        } else{
            NSNumber *val = meats[key];
            float perc = val.floatValue / totalWeight;
            [meats setObject:@(perc) forKey:key];
        }
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
