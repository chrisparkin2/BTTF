//
//  AdjustYieldCell.m
//  BackToTheFarm
//
//  Created by Siddhant Dange on 1/9/15.
//  Copyright (c) 2015 Siddhant Dange. All rights reserved.
//

#import "AdjustYieldCell.h"

@implementation AdjustYieldCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)addButtonHit:(id)sender {
    if(_hitDelegate && _meatAddAction){
        [_hitDelegate performSelectorOnMainThread:_meatAddAction withObject:self waitUntilDone:NO];
    }
}
- (IBAction)subtractButtonHit:(id)sender {
    if(_hitDelegate && _meatSubtractAction){
        [_hitDelegate performSelectorOnMainThread:_meatSubtractAction withObject:self waitUntilDone:NO];
    }
}

@end
