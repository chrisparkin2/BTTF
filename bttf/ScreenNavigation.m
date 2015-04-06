//
//  ScreenNavigation.m
//  Pal
//
//  Created by Siddhant Dange on 7/20/14.
//  Copyright (c) 2014 Siddhant Dange. All rights reserved.
//

#import "ScreenNavigation.h"
#import "Screen.h"

@interface ScreenNavigation ()

@end

@implementation ScreenNavigation

-(void)startWithScreen:(NSString *)screenName data:(NSDictionary*)data animated:(BOOL)animated{
    
    Screen *screen = [(Screen*)[NSClassFromString(screenName) alloc] initWithData:data nibName:screenName bundle:[NSBundle mainBundle]];
    [self pushViewController:screen animated:animated];
    
    
}

-(void)popToStart{
    for(int i = 0; i < self.viewControllers.count; i++){
        [((Screen*)self.viewControllers[i]) popScreenWithAnimation:NO];
    }
}

-(void)popAllAndStartWithScreen:(NSString *)screenName data:(NSDictionary*)data animated:(BOOL)animated{
    [self popToStart];
}

-(void)popChapter{
    for(int i = (int)self.viewControllers.count - 1; i >= 0; i--){
        Screen *screen = (Screen*)self.viewControllers[i];
        if(!screen.breakpoint){
            [screen popScreenWithAnimation:NO];
        } else{
            break;
        }
    }
}

@end
