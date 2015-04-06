//
//  BFSubmitTableViewCell.h
//  bttf
//
//  Created by Admin on 2/21/15.
//  Copyright (c) 2015 bttf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BFSubmitTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *submitLabel;

- (void)setEnabled:(BOOL)enabled animated:(BOOL)animated;

@end
