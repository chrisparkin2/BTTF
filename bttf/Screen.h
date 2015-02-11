//
//  Screen.h
//  SidUI
//
//  Created by Siddhant Dange on 6/18/14.
//  Copyright (c) 2014 Siddhant Dange. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Screen : UIViewController

@property (nonatomic, strong) NSDictionary *passedData;
@property (nonatomic, assign) BOOL breakpoint;

-(id)initWithData:(NSDictionary*)data nibName:(NSString*)nibName bundle:(NSBundle*)bundle;
-(void)goToScreen:(NSString*)screenName animated:(BOOL)animated;
-(void)goToScreen:(NSString *)screenName animated:(BOOL)animated withData:(NSDictionary*)data;
-(void)setup;
-(void)popScreenWithAnimation:(BOOL)animation;

@end
