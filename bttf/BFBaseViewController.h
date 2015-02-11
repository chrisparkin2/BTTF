//
//  JTBaseViewController.h
//  Foosed
//
//  Created by Admin on 10/8/14.
//  Copyright (c) 2015 Ramsel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BFBaseViewController : UIViewController


- (void)hasError:(NSError *)error;
- (void)hasErrorWithLocalizedDescription:(NSString*)localizedDescription;

- (void)handleNetworkTimeout:(NSTimer *)aTimer;

- (void) backButtonAction:(id)sender;
@end
