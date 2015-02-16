//
//  CategoryProduct.m
//  bttf
//
//  Created by Admin on 2/11/15.
//  Copyright (c) 2015 bttf. All rights reserved.
//

#import "CategoryProduct.h"
#import "CategoryMain.h"
#import "CategorySub.h"

@implementation CategoryProduct

#pragma mark MTLJSONSerializing
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"objectId" : @"_id",
             @"name" : @"name",
             @"categoryMainId" : @"_category_main_id",
             @"categorySubId" : @"_category_sub_id"

             };
}

#pragma mark - Keys
+ (NSString*)categoryMainIdKey {
    return @"categoryMainId";
}
+ (NSString*)categorySubIdKey {
    return @"categorySubId";

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



@end
