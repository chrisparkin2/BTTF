//
//  CategorySub.m
//  bttf
//
//  Created by Admin on 2/11/15.
//  Copyright (c) 2015 bttf. All rights reserved.
//

#import "CategorySub.h"
#import "CategoryMain.h"

@implementation CategorySub

#pragma mark MTLJSONSerializing
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"name" : @"name",
             @"categoryMain" : @"category_main"
             };
}

+ (NSValueTransformer *)categoryMainJSONTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:CategoryMain.class];
}


@end
