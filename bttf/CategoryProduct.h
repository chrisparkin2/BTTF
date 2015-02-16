//
//  CategoryProduct.h
//  bttf
//
//  Created by Admin on 2/11/15.
//  Copyright (c) 2015 bttf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>
#import "CategoryAbstract.h"

@class  CategoryMain;
@class  CategorySub;

@interface CategoryProduct : CategoryAbstract <MTLJSONSerializing>


@property (nonatomic) NSString* objectId;
@property (nonatomic) NSString* name;
@property (nonatomic) NSString* categoryMain;
@property (nonatomic) NSString* categorySub;

#pragma mark - Keys
+ (NSString*)categoryMainKey;
+ (NSString*)categorySubKey;

@end
