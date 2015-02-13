//
//  BFAddProductViewController.m
//  bttf
//
//  Created by Admin on 2/12/15.
//  Copyright (c) 2015 bttf. All rights reserved.
//

#import "BFAddProductViewController.h"

@interface BFAddProductViewController ()
@property (weak, nonatomic) IBOutlet UITextField *productNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *supplerNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *priceLabel;
@property (weak, nonatomic) IBOutlet UITextField *quantityLabel;
- (IBAction)didTapClear:(id)sender;
- (IBAction)didTapSave:(id)sender;

@end

@implementation BFAddProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)didTapClear:(id)sender {
}

- (IBAction)didTapSave:(id)sender {
}
@end
