//
//  CutInputCell.h
//  BackToTheFarm
//
//  Created by Siddhant Dange on 12/23/14.
//  Copyright (c) 2014 Siddhant Dange. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CutInputCell : UITableViewCell

@property (nonatomic, assign) SEL meatAddAction, subcutAddAction;
@property (nonatomic, strong) id hitDelegate;
@property (weak, nonatomic) IBOutlet UIButton *addSubcutButton;

@property (weak, nonatomic) IBOutlet UILabel *cutNameLabel;

@end
