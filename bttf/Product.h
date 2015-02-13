//
//  BFProduct.h
//  bttf
//
//  Created by Admin on 2/11/15.
//  Copyright (c) 2015 bttf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@class CategoryMain;
@class CategorySub;
@class CategoryProduct;
@class User;

@interface Product : MTLModel <MTLJSONSerializing>

@property (nonatomic) User* user;
@property (nonatomic) NSString* objectId;
@property (nonatomic) NSString* name;
@property (nonatomic) NSNumber* price;
@property (nonatomic) NSString* supplier;
@property (nonatomic) NSString* categoryMain;
@property (nonatomic) NSString* categorySub;
@property (nonatomic) NSString* categoryProduct;

@end
