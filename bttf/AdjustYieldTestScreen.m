//
//  AdjustYieldTestScreen.m
//  BackToTheFarm
//
//  Created by Siddhant Dange on 1/9/15.
//  Copyright (c) 2015 Siddhant Dange. All rights reserved.
//

#import "AdjustYieldTestScreen.h"
#import "AdjustYieldCell.h"
#import "User.h"
#import "PopupView.h"

@interface AdjustYieldTestScreen ()
@property (weak, nonatomic) IBOutlet UITableView *cutTableView;
@property (nonatomic, strong) NSString *generalCutName;
@property (nonatomic, strong) NSMutableDictionary *subCutsWeights, *subCutsPercs, *percsChanged;
@property (nonatomic, strong) NSMutableArray *subCutNames;
@property (nonatomic, assign) BOOL showPercs;
@property (nonatomic, assign) SEL closeBoxSel;
@property (nonatomic, assign) float totalPerc;
@property (nonatomic, strong) PopupView *popup;

@end

@implementation AdjustYieldTestScreen

-(void)setup{
    
    
    _cutTableView.dataSource = self;
    _cutTableView.delegate = self;
    
    [_cutTableView registerNib:[UINib nibWithNibName:@"AdjustYieldCell" bundle:nil] forCellReuseIdentifier:@"AdjustYieldCell"];
    
    _generalCutName = self.passedData[@"general_cut_name"];
    _subCutsWeights = self.passedData[@"subcuts_weights"];
    _subCutsPercs = self.passedData[@"subcuts_percs"];
    _subCutNames = _subCutsWeights.allKeys.mutableCopy;
    _totalPerc = [self generateTotal:_subCutsPercs];
    
    self.navigationController.navigationBar.topItem.title = [NSString stringWithFormat:@"Adjust weights / yeild test: %@", _generalCutName];
    
    [_cutTableView reloadData];
    
    _popup = self.passedData[@"popup_vc"];
    _closeBoxSel = @selector(closeBox:);
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStyleDone target:self action:@selector(shouldCloseBox)];
    self.navigationItem.rightBarButtonItem = closeButton;
}

- (IBAction)weightPercSwitch:(id)sender {
    UISwitch *mpSwitch = (UISwitch*)sender;
    if(_showPercs){
        BOOL success = [self applyPercChanges];
        if(!success){
            [mpSwitch setOn:YES];
        }
    } else{
        _percsChanged = @{}.mutableCopy;
    }
    _showPercs = mpSwitch.isOn;
    [_cutTableView reloadData];
}

-(void)shouldCloseBox{
    if(_showPercs){
        BOOL success = [self applyPercChanges];
        if(success){
            [_popup performSelectorOnMainThread:_closeBoxSel withObject:nil waitUntilDone:YES];
        }
    } else{
        [_popup performSelectorOnMainThread:_closeBoxSel withObject:nil waitUntilDone:YES];
    }
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
    static NSString *cellIdentifier = @"AdjustYieldCell";
    
    // Attempt to request the reusable cell.
    AdjustYieldCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    // No cell available - create one.
    if(cell == nil) {
        cell = [[AdjustYieldCell alloc] init];
    }
    
    cell.hitDelegate = self;
    cell.meatAddAction = @selector(addMeatAction:);
    cell.meatSubtractAction = @selector(subtractMeatAction:);
    [cell.cutNameLabel setText:_subCutNames[indexPath.row]];
    if(_showPercs){
        float perc = [self generateTotal:_subCutsPercs[_subCutNames[indexPath.row]]]/_totalPerc;
        cell.meatWeightLabel.text = [NSString stringWithFormat:@"%.2f%%", perc * 100];
    } else{
        float weight = [self generateTotal:_subCutsWeights[_subCutNames[indexPath.row]]];
        cell.meatWeightLabel.text = [NSString stringWithFormat:@"%.2f lbs", weight];
    }
    
    return cell;
}

#pragma -mark UITableViewDelegate Methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(!_showPercs){
        NSString *cutName = _subCutNames[indexPath.row];
        if(![((NSDictionary*)_subCutsWeights[cutName]).allKeys containsObject:@"Meat"]){
            [self goToScreen:@"AdjustYieldTestScreen" animated:YES withData:@{@"general_cut_name": cutName,
                                                                              @"subcuts_weights" : _subCutsWeights[cutName],
                                                                              @"subcuts_percs" : _subCutsPercs[cutName],
                                                                              @"popup_vc" : _popup}];
        }
    }
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    User *user = [User sharedInstance];
    
    return !user.firstYieldTestComplete;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        User *user = [User sharedInstance];
        NSString *subcutName = _subCutNames[indexPath.row];
        [_subCutsWeights removeObjectForKey:subcutName];
        [user setTotalWeight];
        [user setYieldTestFromMeatData];
    }
}

#pragma -mark cellHitDelegate Methods

-(void)addMeatAction:(id)sender{
    if(!_showPercs){
        AdjustYieldCell *cell = (AdjustYieldCell*)sender;
        NSString *subcutName = cell.cutNameLabel.text;
        UILabel *subcutValueLabel = cell.meatWeightLabel;
        NSDictionary *subPercs = [self generatePercData:_subCutsWeights[subcutName]];
        [self addPoundWeight:_subCutsWeights[subcutName] byPercs:subPercs factor:1];
        [subcutValueLabel setText:[NSString stringWithFormat:@"%.2f lbs", [self generateTotal:_subCutsWeights[subcutName]]]];
    } else{
        AdjustYieldCell *cell = (AdjustYieldCell*)sender;
        NSString *subcutName = cell.cutNameLabel.text;
        UILabel *subcutValueLabel = cell.meatWeightLabel;
        float value = [self generateTotal:_subCutsPercs[subcutName]]/_totalPerc;
        if([_percsChanged.allKeys containsObject:subcutName]){
            value = ((NSNumber*)_percsChanged[subcutName]).floatValue;
        }
        value += 0.0005;
        [subcutValueLabel setText:[NSString stringWithFormat:@"%.2f%%", value * 100]];
        [_percsChanged setObject:@(value) forKey:subcutName];
    }
}

-(void)subtractMeatAction:(id)sender{
    if(!_showPercs){
        AdjustYieldCell *cell = (AdjustYieldCell*)sender;
        NSString *subcutName = cell.cutNameLabel.text;
        UILabel *subcutWeight = cell.meatWeightLabel;
        NSDictionary *subPercs = [self generatePercData:_subCutsWeights[subcutName]];
        [self addPoundWeight:_subCutsWeights[subcutName] byPercs:subPercs factor:-1];
        [subcutWeight setText:[NSString stringWithFormat:@"%.2f lbs", [self generateTotal:_subCutsWeights[subcutName]]]];
    } else{
        AdjustYieldCell *cell = (AdjustYieldCell*)sender;
        NSString *subcutName = cell.cutNameLabel.text;
        UILabel *subcutValueLabel = cell.meatWeightLabel;
        float value = [self generateTotal:_subCutsPercs[subcutName]]/_totalPerc;
        if([_percsChanged.allKeys containsObject:subcutName]){
            value = ((NSNumber*)_percsChanged[subcutName]).floatValue;
        }
        
        value -= 0.0005;
        if(value <= 0){
            value += 0.0005;
        }
        [subcutValueLabel setText:[NSString stringWithFormat:@"%.2f%%", value * 100]];
        [_percsChanged setObject:@(value) forKey:subcutName];
    }
}

-(BOOL)applyPercChanges{
    if([self checkNewPercs]){
        for(NSString *key in _percsChanged){
            float oldValue = [self generateTotal:_subCutsPercs[key]];
            float newValue = ((NSNumber*)_percsChanged[key]).floatValue;
            float ratio = newValue/oldValue;
            
            [self applyPerc:_subCutsPercs[key] ratio:ratio];
        }
        _percsChanged = @{}.mutableCopy;
        
        User *user = [User sharedInstance];
        [user syncPercSuccess:nil failure:nil];
        return YES;
        
    } else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Percentages don't add up to 100%" message:@"Please adjust" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
        UIAlertAction *resetAction = [UIAlertAction actionWithTitle:@"Reset" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            _percsChanged = @{}.mutableCopy;
            [_cutTableView reloadData];
        }];
        [alert addAction:resetAction];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
        
        return NO;
    }
}

-(void)applyPerc:(NSMutableDictionary*)percs ratio:(float)ratio{
        for(NSString *key in percs.allKeys){
            if([percs[key] isKindOfClass:[NSDictionary class]]){
                [self applyPerc:percs[key] ratio:ratio];
            } else{
                float value = ((NSNumber*)percs[key]).floatValue;
                value *= ratio;
                [percs setObject:@(value) forKey:key];
            }
        }
}

-(BOOL)checkNewPercs{
    float total = 0.0;
    for(NSString *key in _subCutsPercs.allKeys){
        if([_percsChanged.allKeys containsObject:key]){
            total += ((NSNumber*)_percsChanged[key]).floatValue;
        } else{
            total += [self generateTotal:_subCutsPercs[key]]/[self generateTotal:_subCutsPercs];
        }
    }
    
    float roundedTotal = [NSString stringWithFormat:@"%.4f", total].floatValue * 1000;
    roundedTotal =  (float) (unsigned int) (roundedTotal + 0.6f);
    
    return roundedTotal == 1000.0 || _percsChanged == nil;
}

-(void)addPoundWeight:(NSMutableDictionary*)weights byPercs:(NSDictionary*)percs factor:(int)factor{
    for(NSString *key in weights.allKeys){
        if([weights[key] isKindOfClass:[NSDictionary class]]){
            [self addPoundWeight:weights[key] byPercs:percs[key] factor:factor];
        } else{
            float perc = ((NSNumber*)percs[key]).floatValue;
            float weight = ((NSNumber*)weights[key]).floatValue;
            weight += perc * factor;
            [weights setObject:@(weight) forKey:key];
        }
    }
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
