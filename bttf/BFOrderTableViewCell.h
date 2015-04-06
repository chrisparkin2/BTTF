//
//  BFOrderTableViewCell.h
//  bttf
//
//  Created by Admin on 2/20/15.
//  Copyright (c) 2015 bttf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserProduct.h"


@protocol BFOrderTableViewCellDelegate;


@interface BFOrderTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *quantityBatchesLabel;
@property (weak, nonatomic) IBOutlet UILabel *quantityBatchSizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *quantityUnitsTotalLabel;
@property (weak, nonatomic) IBOutlet UIView *statusDotView;
@property (weak, nonatomic) IBOutlet UIButton *rightArrow;
@property (weak, nonatomic) IBOutlet UIButton *leftArrow;

- (void)setOrderStatus:(BFOrderStatusIndex)orderStatus;

- (IBAction)didTapEditButton:(id)sender;
- (IBAction)didTapRightArrow:(id)sender;
- (IBAction)didTapLeftArrow:(id)sender;

@property (weak, nonatomic) id<BFOrderTableViewCellDelegate>delegate;

@end

@protocol BFOrderTableViewCellDelegate <NSObject>
- (void)didTapEditButton:(UITableViewCell*)orderCell;
- (void)didTapIncreaseBatchesButton:(UITableViewCell*)orderCell;
- (void)didTapDecreaseBatchesButton:(UITableViewCell*)orderCell;
- (void)didTapQuantityLabel:(UITableViewCell*)orderCell;


@end
