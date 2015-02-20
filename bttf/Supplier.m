//
//  Supplier.m
//  bttf
//
//  Created by Admin on 2/20/15.
//  Copyright (c) 2015 bttf. All rights reserved.
//

#import "Supplier.h"

@implementation Supplier

#pragma mark MTLJSONSerializing
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"objectId" : @"_id",
             @"name" : @"name"
             };
}

@end
