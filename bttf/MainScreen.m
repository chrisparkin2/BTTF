//
//  MainScreen.m
//  BackToTheFarm
//
//  Created by Siddhant Dange on 11/27/14.
//  Copyright (c) 2014 Siddhant Dange. All rights reserved.
//

#import "MainScreen.h"
#import "AppDelegate.h"
#import "User.h"
#import "PopupView.h"

@interface MainScreen ()

@end

@implementation MainScreen

-(void)setup{
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)viewDidLoad{
    
//    PopupView *pv = [[PopupView alloc] initWithScreen:@"LoginScreen" andData:nil onScreen:self];
//    pv.delegate = self;
//    pv.closeAction = @selector(loginBoxClosed);
//    [self.view addSubview:pv];
    
    User *user = [User sharedInstance];
    if(!user.firstYieldTestComplete){
        //add new item
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"No Yield Test Done"
                                              message:@"Enter weights to complete"
                                              preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:@"Ok!"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"Cancel action");
                                   }];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }

}

-(void)loginBoxClosed{
    User *user = [User sharedInstance];
    if(!user.firstYieldTestComplete){
        //add new item
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"No Yield Test Done"
                                              message:@"Enter weights to complete"
                                              preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction *okAction = [UIAlertAction
                                       actionWithTitle:@"Ok!"
                                       style:UIAlertActionStyleCancel
                                       handler:^(UIAlertAction *action)
                                       {
                                           NSLog(@"Cancel action");
                                       }];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (IBAction)animalClicked:(id)sender {
    int tag = (int)((UIButton*)sender).tag;
    
    NSString *animalName;
    switch (tag) {
        case 0:
            animalName = @"cow";
            break;
        case 1:
            animalName = @"pig";
            break;
        case 2:
            animalName = @"sheep";
            break;
        case 3:
            animalName = @"goat";
            break;
            
        default:
            break;
    }
    
    
    User *user = [User sharedInstance];
    if(user.meatData[animalName] && ((NSDictionary*)user.meatData[animalName]).allKeys.count){
        
        NSDictionary* animalPercData = [user getPercData][animalName];
        if (!animalPercData) animalPercData = [NSDictionary new];
        
        [self goToScreen:@"InfoScreen" animated:YES withData:@{@"meat_data" : user.meatData[animalName], @"perc_data" : animalPercData, @"general_cut_name" : animalName}];
    }
}
- (IBAction)addAnimalPounds:(id)sender {
    User *user = [User sharedInstance];
    PopupView *pv = [[PopupView alloc] initWithScreen:@"AddMeatScreen" andData:@{@"general_cut_name" : @"general", @"subcuts_weights" : user.meatData,  @"subcuts_percs" : [user getPercData], @"first_yeild_test_mode" : @(!user.firstYieldTestComplete)} onScreen:self];
    pv.delegate = self;
    pv.closeAction = @selector(meatAddPopupClosed);
    [self.view addSubview:pv];
    
    
}
- (IBAction)refreshHit:(id)sender {
    User *user = [User sharedInstance];
    [user readMeatFromCloud:^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Refreshed" message:@"Updated Meat Data" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    } failure:nil];
}

-(void)meatAddPopupClosed{
    User *user = [User sharedInstance];
    if (!user.firstYieldTestComplete) {
        [user setYieldTestFromMeatData];
        user.firstYieldTestComplete = YES;
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
