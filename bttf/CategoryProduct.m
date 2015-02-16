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
             @"categoryMain" : @"category_main",
             @"categorySub" : @"category_sub"

             };
}

#pragma mark - Keys
+ (NSString*)categoryMainKey {
    return @"categoryMain";
}
+ (NSString*)categorySubKey {
    return @"categorySub";
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
