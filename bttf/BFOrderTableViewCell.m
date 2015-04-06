//
//  BFOrderTableViewCell.m
//  bttf
//
//  Created by Admin on 2/20/15.
//  Copyright (c) 2015 bttf. All rights reserved.
//

#import "BFOrderTableViewCell.h"
#import "UIColor+Extensions.h"

@implementation BFOrderTableViewCell

- (void)awakeFromNib {
    
    // Initialization code
    self.statusDotView.layer.cornerRadius = (self.statusDotView.frame.size.height)/2;
    self.statusDotView.backgroundColor = [UIColor whiteColor];
    
    
    
    // Flip leftTriangleView
    [self.rightArrow.layer setAffineTransform:CGAffineTransformMakeScale(-1, 1)];

    
    // Add gesture to quantityLabel
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapQuantityLabel:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self.quantityUnitsTotalLabel addGestureRecognizer:tap];
    self.quantityUnitsTotalLabel.userInteractionEnabled = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
}



- (void)setOrderStatus:(BFOrderStatusIndex)orderStatus {
    
    switch (orderStatus) {
        case BFOrderStatusOK:
            self.statusDotView.backgroundColor = [UIColor greenColor];
            break;
            
        case BFOrderStatusCritical:
            self.statusDotView.backgroundColor = [UIColor redColor];
            break;
            
        default:
            break;
    }
    
}

#pragma mark - Actions
- (IBAction)didTapEditButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTapEditButton:)]) {
        [self.delegate didTapEditButton:self];
    }
}

- (IBAction)didTapRightArrow:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTapIncreaseBatchesButton:)]) {
        [self.delegate didTapIncreaseBatchesButton:self];
    }

}

- (IBAction)didTapLeftArrow:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTapDecreaseBatchesButton:)]) {
        [self.delegate didTapDecreaseBatchesButton:self];
    }

}


- (void)didTapQuantityLabel:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTapQuantityLabel:)]) {
        [self.delegate didTapQuantityLabel:self];
    }
    
}



@end
