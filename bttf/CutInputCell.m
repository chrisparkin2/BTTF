//
//  CutInputCell.m
//  BackToTheFarm
//
//  Created by Siddhant Dange on 12/23/14.
//  Copyright (c) 2014 Siddhant Dange. All rights reserved.
//

#import "CutInputCell.h"

@implementation CutInputCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)addCutData:(id)sender {
    if(_hitDelegate && _meatAddAction){
        [_hitDelegate performSelectorOnMainThread:_meatAddAction withObject:_cutNameLabel.text waitUntilDone:NO];
    }
    
}
- (IBAction)addSubcutData:(id)sender {
    if(_hitDelegate && _subcutAddAction){
        [_hitDelegate performSelectorOnMainThread:_subcutAddAction withObject:_cutNameLabel.text waitUntilDone:NO];
    }
}

@end
