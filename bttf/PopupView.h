//
//  PopupView.h
//  BackToTheFarm
//
//  Created by Siddhant Dange on 12/23/14.
//  Copyright (c) 2014 Siddhant Dange. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Screen;
@interface PopupView : UIView

@property (nonatomic, strong) id delegate;
@property (nonatomic, assign) SEL closeAction;

-(instancetype)initWithScreen:(NSString*)screenName andData:(NSDictionary*)data onScreen:(Screen*)overScreen;

- (IBAction)closeBox:(id)sender;

@end
