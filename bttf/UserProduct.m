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
             @"categoryMain" : @"category_main",
             @"categorySub" : @"category_sub",
             @"categoryProduct" : @"category_product"
             };
}

#pragma mark - Keys
+ (NSString*)categoryMainKey {
    return @"categoryMain";
}
+ (NSString*)categorySubKey {
    return @"categorySub";
}
+ (NSString*)categoryProductKey {
    return @"categoryProduct";
}


//+ (NSValueTransformer *)categoryMainJSONTransformer
//{
//    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:CategoryMain.class];
//}
//
//+ (NSValueTransformer *)categorySubJSONTransformer
//{
//    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:CategorySub.class];
//}
//
//+ (NSValueTransformer *)categoryProductJSONTransformer
//{
//    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:CategoryProduct.class];
//}
//
//+ (NSValueTransformer *)userJSONTransformer
//{
//    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:User.class];
//}


@end
