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
        _quantity = @(0);
    }
    return self;
}

- (BOOL) isValid {
    if (!self.userId || !self.price || !self.name || !self.quantity) return NO;
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
             @"categoryMain" : @"_category_main",
             @"categorySub" : @"_category_sub",
             @"categoryProduct" : @"_category_product"
             };
}

+ (NSValueTransformer *)categoryMainJSONTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:CategoryMain.class];
}

+ (NSValueTransformer *)categorySubJSONTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:CategorySub.class];
}

+ (NSValueTransformer *)categoryProductJSONTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:CategoryProduct.class];
}

+ (NSValueTransformer *)userJSONTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:User.class];
}


@end
