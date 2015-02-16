//
//  CategorySub.h
//  bttf
//
//  Created by Admin on 2/11/15.
//  Copyright (c) 2015 bttf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>
#import "CategoryAbstract.h"

@class CategoryMain;

@interface CategorySub : CategoryAbstract <MTLJSONSerializing>

@property (nonatomic) NSString* objectId;
@property (nonatomic) NSString* name;
@property (nonatomic) NSString* categoryMain;

#pragma mark - Keys
+ (NSString*)categoryMainKey;

@end
