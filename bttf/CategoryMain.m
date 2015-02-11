//
//  BFCategory.m
//  bttf
//
//  Created by Admin on 2/10/15.
//  Copyright (c) 2015 bttf. All rights reserved.
//

#import "CategoryMain.h"

@implementation CategoryMain

#pragma mark MTLJSONSerializing
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"name" : @"name"
             };
}




@end
