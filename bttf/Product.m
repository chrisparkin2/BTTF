//
//  BFProduct.m
//  bttf
//
//  Created by Admin on 2/11/15.
//  Copyright (c) 2015 bttf. All rights reserved.
//

#import "Product.h"
#import "CategoryMain.h"
#import "CategorySub.h"
#import "CategoryProduct.h"

@implementation Product

#pragma mark MTLJSONSerializing
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"name" : @"name",
             @"price" : @"price",
             @"supplier" : @"supplier",
             @"categoryMain" : @"category_main",
             @"categorySub" : @"category_sub",
             @"categoryProduct" : @"category_product"
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


@end
