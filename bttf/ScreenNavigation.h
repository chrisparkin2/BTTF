//
//  ScreenNavigation.h
//  Pal
//
//  Created by Siddhant Dange on 7/20/14.
//  Copyright (c) 2014 Siddhant Dange. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScreenNavigation : UINavigationController

-(void)startWithScreen:(NSString *)screenName data:(NSDictionary*)data animated:(BOOL)animated;
-(void)popToStart;
-(void)popAllAndStartWithScreen:(NSString*)screen data:(NSDictionary*)data animated:(BOOL)animated;
-(void)popChapter;

@end
