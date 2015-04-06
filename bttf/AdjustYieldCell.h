//
//  AdjustYieldCell.h
//  BackToTheFarm
//
//  Created by Siddhant Dange on 1/9/15.
//  Copyright (c) 2015 Siddhant Dange. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdjustYieldCell : UITableViewCell

@property (nonatomic, assign) SEL meatAddAction, meatSubtractAction;
@property (nonatomic, strong) id hitDelegate;

@property (weak, nonatomic) IBOutlet UILabel *cutNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *meatWeightLabel;
@property (weak, nonatomic) IBOutlet UIButton *subtractionButton;


@end
