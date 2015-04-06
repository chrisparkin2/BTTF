//
//  AppDelegate.m
//  bttf
//
//  Created by Admin on 2/10/15.
//  Copyright (c) 2015 bttf. All rights reserved.
//

#import "AppDelegate.h"
#import "BFNavController.h"
#import "BFClientAPI.h"
#import "User.h"

@interface AppDelegate () 


@property (nonatomic, strong) BFNavController* navController;


@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {


    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    // Reload data
    [[BFClientAPI sharedAPI] reloadGenericData];
    
    if ([User sharedInstance].token) [[BFClientAPI sharedAPI] reloadUserSpecificData];

    
}




#ifdef DEBUG
#pragma mark - Admin
- (void)runAdmin {
    
    
}

#endif
@end
