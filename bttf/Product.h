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

@interface Product : MTLModel <MTLJSONSerializing>

@property (nonatomic) NSString* name;
@property (nonatomic) NSNumber* price;
@property (nonatomic) NSString* supplier;
@property (nonatomic) CategoryMain* categoryMain;
@property (nonatomic) CategorySub* categorySub;
@property (nonatomic) CategoryProduct* categoryProduct;


@end
