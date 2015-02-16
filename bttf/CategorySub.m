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
    return @{@"objectId" : @"_id",
             @"name" : @"name",
             @"categoryMainId" : @"_category_main_id"
             };
}


#pragma mark - Keys
+ (NSString*)categoryMainIdKey {
    return @"categoryMainId";
}

//+ (NSValueTransformer *)categoryMainJSONTransformer
//{
//    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:CategoryMain.class];
//}


@end
