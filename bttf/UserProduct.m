//
//  BFProduct.m
//  bttf
//
//  Created by Admin on 2/11/15.
//  Copyright (c) 2015 bttf. All rights reserved.
//

#import "UserProduct.h"
#import "CategoryMain.h"
#import "CategorySub.h"
#import "CategoryProduct.h"
#import "User.h"

@implementation UserProduct

#pragma mark - Logic
- (instancetype)init {
    
    self = [super init];
    if (self) {
        _quantityBulk = @(0);
    }
    return self;
}

- (BOOL) isValid {
    if (!self.userId || !self.price || !self.name || !self.quantityBulk) return NO;
    return YES;
}

- (void)setValuesFromCategoryProduct:(CategoryProduct*)categoryProduct {
    
    self.categoryProductId = categoryProduct.objectId;
    self.categorySubId = categoryProduct.categorySubId;
    self.categoryMainId = categoryProduct.categoryMainId;
}

#pragma mark MTLJSONSerializing
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"objectId" : @"_id",
             @"userId" : @"user_id",
             @"name" : @"name",
             @"price" : @"price",
             @"supplier" : @"supplier",
             @"quantityBulk" : @"quantity_bulk",
             @"quantityPerCase" : @"quantity_per_case",
             @"quantityUnits" : @"quantity_units",
             @"categoryMainId" : @"_category_main_id",
             @"categorySubId" : @"_category_sub_id",
             @"categoryProductId" : @"_category_product_id"
             };
}


#pragma mark - Keys
+ (NSString*)categoryMainIdIdKey {
    return @"categoryMainId";
}
+ (NSString*)categorySubIdKey {
    return @"categorySubId";
}
+ (NSString*)categoryProductIdKey {
    return @"categoryProductId";
}





@end
