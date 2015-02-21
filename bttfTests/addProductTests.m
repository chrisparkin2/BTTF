//
//  bttfTests.m
//  bttfTests
//
//  Created by Admin on 2/10/15.
//  Copyright (c) 2015 bttf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "AddProduct.h"

@interface AddProduct (tests)

@property (weak, nonatomic) IBOutlet UITextField *quantityBulkTextField;
@property (weak, nonatomic) IBOutlet UITextField *quantityPerCaseTextField;
@property (weak, nonatomic) IBOutlet UITextField *quantityUnitsTextField;

- (void)calculateUnits;

@end

@interface addProductTests : XCTestCase

@property (nonatomic, strong) AddProduct* addProductVC;

@end

@implementation addProductTests


- (void)setUp {
    [super setUp];

    self.addProductVC = [AddProduct new];
    [self.addProductVC loadView];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCalculateUnits {
    
    // positive values
    self.addProductVC.quantityBulkTextField.text = @"2";
    self.addProductVC.quantityPerCaseTextField.text = @"24";
    
    [self.addProductVC calculateUnits];
    
    XCTAssertEqualObjects(self.addProductVC.quantityUnitsTextField.text, @"48", @"calculateUnits not equal 2*24=48");
    
    // 0 value
    self.addProductVC.quantityBulkTextField.text = @"0";
    self.addProductVC.quantityPerCaseTextField.text = @"24";
    
    [self.addProductVC calculateUnits];
    
    XCTAssertEqualObjects(self.addProductVC.quantityUnitsTextField.text, @"0", @"calculateUnits not equal 0*24=0");

}

@end

