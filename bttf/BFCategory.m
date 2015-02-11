//
//  BFCategory.m
//  bttf
//
//  Created by Admin on 2/10/15.
//  Copyright (c) 2015 bttf. All rights reserved.
//

#import "BFCategory.h"

@implementation BFCategory

#pragma mark MTLJSONSerializing
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"name" : @"name",
             @"level" : @"level",
             @"parent" : @"parent"
             };
}

+ (NSValueTransformer *)parentJSONTransformer
{
   return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:BFCategory.class];
}


@end
