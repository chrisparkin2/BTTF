//
//  JTBaseViewController.m
//  Foosed
//
//  Created by Admin on 10/8/14.
//  Copyright (c) 2015 Ramsel. All rights reserved.
//

#import "BFBaseViewController.h"

@interface BFBaseViewController ()

@property (nonatomic, strong) NSTimer* networkTimer;

@end

@implementation BFBaseViewController

- (void)awakeFromNib {
    
    [super awakeFromNib];

}

- (void) viewDidLoad {
    [super viewDidLoad];
    
    // Actitivy View
    self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityView.center = self.view.center;
    self.activityView.hidesWhenStopped = YES;
    
    [self.view addSubview:self.activityView];
    [self.view bringSubviewToFront:self.activityView];

}


#pragma mark - Navigation
- (void) backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Error Handling
- (void)hasError:(NSError *)error {
    
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error")
                                                      message:[NSString stringWithFormat:@"%@",[error localizedDescription]]
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


#pragma mark - UIActivityIndicatorView
- (void)animateActivityIndicatorAndSetTimer {
    [self.view bringSubviewToFront:self.activityView];
    [self.activityView startAnimating];
    
    // If more than 10 seconds pass, stop waiting for the server to respond
    self.networkTimer = [NSTimer scheduledTimerWithTimeInterval:10.0f target:self selector:@selector(handleNetworkTimeout:) userInfo:nil repeats:NO];

}

- (void)stopActivityIndicatorAndTimer {
    [self.networkTimer invalidate];
    
    [self.activityView stopAnimating];
}


- (void)handleNetworkTimeout:(NSTimer *)aTimer {
    
    [self.networkTimer invalidate];
    self.networkTimer = nil;
    
    NSMutableDictionary* details = [NSMutableDictionary dictionary];
    [details setValue:@"No network connection." forKey:NSLocalizedDescriptionKey];
    NSError*error = [NSError errorWithDomain:@"network" code:200 userInfo:details];
    [self hasError:error];
    
}

@end
