//
//  LoginScreen.m
//  BackToTheFarm
//
//  Created by Siddhant Dange on 1/10/15.
//  Copyright (c) 2015 Siddhant Dange. All rights reserved.
//

#import "LoginScreen.h"
#import "PopupView.h"
#import "User.h"

@interface LoginScreen ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UISwitch *loginSignUpSwitch;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinnerView;

@end

@implementation LoginScreen

-(void)setup{
    _signUpButton.userInteractionEnabled = NO;
    _signUpButton.alpha = 0.5;
    
    _loginButton.userInteractionEnabled = YES;
    _loginButton.alpha = 1.0;
    
    _emailTextField.userInteractionEnabled = NO;
    _emailTextField.alpha = 0.0f;

    
    self.navigationController.navigationBar.topItem.title = @"Login/Signup";
    if(![self connected]){
    //    [self showDialogWithTitle:@"Cannot Reach" andMessage:@"Connect to internet"];
    }
}
- (IBAction)switchAction:(id)sender {
    UISwitch *lsSwitch = (UISwitch*)sender;
    if(lsSwitch.isOn){
        _loginButton.userInteractionEnabled = NO;
        _loginButton.alpha = 0.5;
        
        _signUpButton.userInteractionEnabled = YES;
        _signUpButton.alpha = 1.0;
        
        _emailTextField.userInteractionEnabled = YES;
        _emailTextField.alpha = 1.0f;
    } else{
        _signUpButton.userInteractionEnabled = NO;
        _signUpButton.alpha = 0.5;
        
        _loginButton.userInteractionEnabled = YES;
        _loginButton.alpha = 1.0;
        
        _emailTextField.userInteractionEnabled = NO;
        _emailTextField.alpha = 0.0f;
    }
}

-(BOOL)validateFields:(int)signup{
    NSString *username = [self trimString: _usernameTextField.text];
    NSString *password = [self trimString: _passwordTextField.text];
    NSString *email = [self trimString:_emailTextField.text];
    
    BOOL filledOut = username.length && password.length;// && [self NSStringIsValidEmail:password];
    if(signup){
        return filledOut && email.length;
    }
    
    return filledOut;
}

-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO; // Discussion
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

-(NSString*)trimString:(NSString*)string{
    return [string stringByTrimmingCharactersInSet:
            [NSCharacterSet whitespaceCharacterSet]];
}

-(void)showDialogWithTitle:(NSString*)title andMessage:(NSString*)message{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)signUpAction:(id)sender {
    User *user = [User sharedInstance];
    if([self validateFields:1]){
        [_spinnerView startAnimating];
        [_signUpButton setUserInteractionEnabled:NO];
        [user createUserWithUsername:_usernameTextField.text password:_passwordTextField.text email:_emailTextField.text completion:^(NSDictionary *data) {
            [_spinnerView stopAnimating];
            [_signUpButton setUserInteractionEnabled:YES];
            int statusCode = ((NSNumber*)data[@"status"]).intValue;
            
            //failed then show message
            if(statusCode == 200){
                [self showDialogWithTitle:@"Error signing up" andMessage:data[@"message"]];
            } else if(statusCode == 100){
                PopupView *pv = self.passedData[@"popup_vc"];
                [pv closeBox:nil];
            }
            
            // FIXME: handle status codes other than 100 or 200
        }];
    } else{
        [self showDialogWithTitle:@"Incomplete Form" andMessage:@"Fill out all fields correctly"];
    }
}

- (IBAction)loginAction:(id)sender {
    User *user = [User sharedInstance];
    
    if([self validateFields:0]){
        [_spinnerView startAnimating];
        [_loginButton setUserInteractionEnabled:NO];
        [user loginUserWithUsername:_usernameTextField.text password:_passwordTextField.text completion:^(NSDictionary *data) {
            [_spinnerView stopAnimating];
            [_loginButton setUserInteractionEnabled:YES];
            int statusCode = ((NSNumber*)data[@"status"]).intValue;
            
            //failed then show message
            if(statusCode == 200){
                [self showDialogWithTitle:@"Error logging in" andMessage:data[@"message"]];
            } else if(statusCode == 100){
                if(user.firstYieldTestComplete){
                    [user readMeatFromCloud:^{
                        PopupView *pv = self.passedData[@"popup_vc"];
                        [pv closeBox:nil];
                    } failure:^(NSString *message) {
                        [self showDialogWithTitle:@"Error syncing meat data with server" andMessage:@"Please close and reopen app"];
                    }];
                } else{
                    PopupView *pv = self.passedData[@"popup_vc"];
                    [pv closeBox:nil];
                }
            }
        }];
    } else{
        [self showDialogWithTitle:@"Incomplete Form" andMessage:@"Fill out all fields correctly"];
    }
}

-(BOOL)connected{
    NSURL *scriptUrl = [NSURL URLWithString:@"http://apps.wegenerlabs.com/hi.html"];
    NSData *data = [NSData dataWithContentsOfURL:scriptUrl];
    return data;
}

@end
