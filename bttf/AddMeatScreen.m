//
//  InputCutDataScreen.m
//  BackToTheFarm
//
//  Created by Siddhant Dange on 12/23/14.
//  Copyright (c) 2014 Siddhant Dange. All rights reserved.
//

#import "AddMeatScreen.h"
#import "CutInputCell.h"
#import "PopupView.h"
#import "User.h"

@interface AddMeatScreen ()
@property (weak, nonatomic) IBOutlet UITableView *cutTableView;
@property (nonatomic, weak) IBOutlet UILabel *generalCutNameLabel;
@property (nonatomic, strong) NSString *generalCutName;
@property (nonatomic, strong) NSMutableDictionary *subCutsWeights, *subCutsPercs;
@property (nonatomic, strong) NSMutableArray *subCutNames;
@property (nonatomic, assign) BOOL firstYieldTestMode;
@property (nonatomic, strong) PopupView *popup;

@end

@implementation AddMeatScreen

-(void)setup{
    
    
    self.navigationController.navigationBar.topItem.title = @"Add meat";
    
    _cutTableView.dataSource = self;
    _cutTableView.delegate = self;
    
    [_cutTableView registerNib:[UINib nibWithNibName:@"CutInputCell" bundle:nil] forCellReuseIdentifier:@"CutInputCell"];
    
    _generalCutName = self.passedData[@"general_cut_name"];
    [_generalCutNameLabel setText:_generalCutName];
    _subCutsWeights = self.passedData[@"subcuts_weights"];
    _subCutsPercs = self.passedData[@"subcuts_percs"];
    _firstYieldTestMode = ((NSNumber*)self.passedData[@"first_yeild_test_mode"]).boolValue;
    _subCutNames = _subCutsWeights.allKeys.mutableCopy;
    [_cutTableView reloadData];
    
    _popup = self.passedData[@"popup_vc"];
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStyleDone target:_popup action:@selector(closeBox:)];
    self.navigationItem.rightBarButtonItem = closeButton;
}

#pragma -mark UITableViewDataSource Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    int numRows = (int)_subCutNames.count;
    return numRows;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // Identifier for retrieving reusable cells.
    static NSString *cellIdentifier = @"CutInputCell";
    
    // Attempt to request the reusable cell.
    CutInputCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    // No cell available - create one.
    if(cell == nil) {
        cell = [[CutInputCell alloc] init];
    }
    
    cell.hitDelegate = self;
    cell.meatAddAction = @selector(cellMeatAddHit:);
    cell.subcutAddAction = @selector(cellSubcutAddHit:);
    [cell.cutNameLabel setText:_subCutNames[indexPath.row]];
    
    if([_subCutNames containsObject:@"Meat"] || !_firstYieldTestMode){
        cell.addSubcutButton.hidden = YES;
    }
    
    return cell;
}

#pragma -mark UITableViewDelegate Methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cutName = _subCutNames[indexPath.row];
    if([_subCutsWeights[cutName] isKindOfClass:[NSDictionary class]]){
        if(((NSDictionary*)_subCutsWeights[cutName]).allKeys.count){
            NSObject *passedPercs = [NSNull null];
            if(!_firstYieldTestMode){
                passedPercs = _subCutsPercs[cutName];
            }
            [self goToScreen:@"AddMeatScreen" animated:YES withData:@{@"general_cut_name": cutName,
                                                                      @"subcuts_weights" : _subCutsWeights[cutName],
                                                                      @"subcuts_percs" : passedPercs,
                                                                      @"first_yeild_test_mode" : @(_firstYieldTestMode),
                                                                      @"popup_vc" : _popup}];
        } else{
            
            UIAlertController *alertController = [UIAlertController
                                                  alertControllerWithTitle:@"No Subcuts"
                                                  message:@"Please add a subcut"
                                                  preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction
                                           actionWithTitle:@"Ok"
                                           style:UIAlertActionStyleCancel
                                           handler:^(UIAlertAction *action)
                                           {
                                               NSLog(@"Cancel action");
                                           }];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }
}

#pragma -mark cellHitDelegate Methods

-(void)cellSubcutAddHit:(NSString*)cutName{
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Add Subcut"
                                          message:nil
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        [textField setPlaceholder:@"Subcut Name"];
    }];
    
    
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:@"Cancel"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"Cancel action");
                                   }];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"Add"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   
                                   UITextField *subcutTextField = alertController.textFields[0];
                                   NSString *subcutName = subcutTextField.text;
                                   NSMutableDictionary *innerMeatWeights = _subCutsWeights[cutName];
                                   if ([innerMeatWeights.allKeys containsObject:@"Meat"]) {
                                       _subCutsWeights[cutName] = @{}.mutableCopy;
                                   }
                                   
                                   [_subCutsWeights[cutName] setObject:@{
                                                                @"Meat" : @(0),
                                                                @"Trim" : @(0),
                                                                @"Dogfood" : @(0),
                                                                @"Bones" : @(0),
                                                                @"Waste" : @(0),
                                                                }.mutableCopy forKey:subcutName];
                                   
                                   [_cutTableView reloadData];
                               }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)cellMeatAddHit:(NSString*)cutName{
    
    //add meat by perc
    //add new item
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:cutName
                                          message:@"Add Lbs"
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        [textField setPlaceholder:@"Lbs"];
        [textField setTextAlignment:NSTextAlignmentCenter];
        [textField setKeyboardType:UIKeyboardTypeDecimalPad];
    }];
    
    
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:@"Cancel"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"Cancel action");
                                   }];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"Add"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   
                                   UITextField *weightAddField = alertController.textFields[0];
                                   NSString *weightStr = weightAddField.text;
                                   float totalWeightAdded = weightStr.floatValue;
                                   
                                   if([_subCutsWeights[cutName] isKindOfClass:[NSDictionary class]]){
                                       NSMutableDictionary *percData;
                                       if(!_firstYieldTestMode || !_subCutsPercs){
                                           percData = _subCutsPercs[cutName];
                                       } else {
                                           percData = [self generateEvenPercs:_subCutsWeights[cutName]];
                                       }
                                       
                                       percData = [self generatePercData:percData];
                                       [self multiplySetPercs:percData weights:_subCutsWeights[cutName] andTotalWeight:totalWeightAdded];
                                   } else{
                                       float weight = ((NSNumber*)_subCutsWeights[cutName]).floatValue;
                                       weight += totalWeightAdded;
                                       [_subCutsWeights setObject:@(weight) forKey:cutName];
                                   }
                                   
                                   [_cutTableView reloadData];
                               }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma -mark Meat Conversion Methods

-(NSMutableDictionary*)generateEvenPercs:(NSMutableDictionary*)percs{
    NSMutableDictionary *evenPercs = (NSMutableDictionary*)CFBridgingRelease(CFPropertyListCreateDeepCopy(kCFAllocatorDefault, (CFPropertyListRef)percs, kCFPropertyListMutableContainers));
    [self generateEvenPercsRec:evenPercs total:1.0f];
    return evenPercs;
}

-(void)generateEvenPercsRec:(NSMutableDictionary*)percs total:(float)total{
    for(NSString *key in percs.allKeys){
        if([percs[key] isKindOfClass:[NSDictionary class]]){
            [self generateEvenPercsRec:percs[key] total:total/percs.allKeys.count];
        } else {
            [percs setObject:@(total/percs.allKeys.count) forKey:key];
        }
    }
}

-(void)multiplySetPercs:(NSMutableDictionary*)percs weights:(NSMutableDictionary*)weights andTotalWeight:(float)totalWeight{
    for (NSString *key in percs.allKeys) {
        if([percs[key] isKindOfClass:[NSDictionary class]]){
            [self multiplySetPercs:percs[key] weights:weights[key] andTotalWeight:totalWeight];
        } else{
            NSNumber *perc = percs[key];
            NSNumber *weight = weights[key];
            
            float weight_f = weight.floatValue;
            float perc_f = perc.floatValue;
            weight_f += perc_f * totalWeight;
            [weights setObject:@(weight_f) forKey:key];
        }
    }
}

-(float)generateTotal:(NSDictionary*)meats{
    float total = 0.0f;
    
    if([meats objectForKey:@"Meat"]){
        for(NSString *key in meats){
            total += ((NSNumber*)meats[key]).floatValue;
        }
        
        return total;
    }
    
    for(NSString* key in meats){
        total += [self generateTotal:meats[key]];
    }
    
    return total;
}

-(NSMutableDictionary*)generatePercData:(NSMutableDictionary*)meats{
    float totalWeight = [self generateTotal:meats];
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

@end
