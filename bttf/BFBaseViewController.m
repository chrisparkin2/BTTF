//
//  JTBaseViewController.m
//  Foosed
//
//  Created by Admin on 10/8/14.
//  Copyright (c) 2015 Ramsel. All rights reserved.
//

#import "BFBaseViewController.h"

@implementation BFBaseViewController

- (void)awakeFromNib {
    
    [super awakeFromNib];

}


#pragma mark - Navigation
- (void) backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - ()
- (void)hasError:(NSError *)error {
    
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error")
                                                      message:[NSString stringWithFormat:@"%@ - %@",[error localizedDescription],[error localizedFailureReason]]
                                                     delegate:nil
                                            cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                            otherButtonTitles:nil];
    [message show];
}

- (void)hasErrorWithLocalizedDescription:(NSString*)localizedDescription{
    
    NSMutableDictionary* details = [NSMutableDictionary dictionary];
    [details setValue:localizedDescription forKey:NSLocalizedDescriptionKey];
    NSError*error = [NSError errorWithDomain:@"bttf" code:200 userInfo:details];
    [self hasError:error];
    
}



- (void)handleNetworkTimeout:(NSTimer *)aTimer {
    
    [aTimer invalidate];
    
    NSMutableDictionary* details = [NSMutableDictionary dictionary];
    [details setValue:@"No network connection." forKey:NSLocalizedDescriptionKey];
    NSError*error = [NSError errorWithDomain:@"network" code:200 userInfo:details];
    [self hasError:error];
    
}

@end
