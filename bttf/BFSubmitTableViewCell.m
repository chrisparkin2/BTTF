//
//  BFSubmitTableViewCell.m
//  bttf
//
//  Created by Admin on 2/21/15.
//  Copyright (c) 2015 bttf. All rights reserved.
//

#import "BFSubmitTableViewCell.h"
#import "UIColor+Extensions.h"

@implementation BFSubmitTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setEnabled:(BOOL)enabled animated:(BOOL)animated {
    
    self.userInteractionEnabled = enabled;
    
    // Configure the view for the selected state
    if (enabled) {
        self.submitLabel.textColor = [UIColor colorFog];
    }
    else {
        self.submitLabel.textColor = [UIColor lightGrayColor];
    }
    
    [self layoutIfNeeded];
}


@end
