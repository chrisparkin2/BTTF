//
//  BFProduct.h
//  bttf
//
//  Created by Admin on 2/11/15.
//  Copyright (c) 2015 bttf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

typedef enum {
    BFOrderStatusOK,
    BFOrderStatusLow,
    BFOrderStatusCritical
} BFOrderStatusIndex;

#define defaultTrigger 5

@class CategoryMain;
@class CategorySub;
@class CategoryProduct;
@class User;

@interface UserProduct : MTLModel <MTLJSONSerializing>

@property (nonatomic) NSString* userId;
@property (nonatomic) NSString* objectId;
@property (nonatomic) NSString* name;
@property (nonatomic) NSNumber* price;
@property (nonatomic) NSString* supplier;
@property (nonatomic) NSNumber* quantityBulk;
@property (nonatomic) NSNumber* quantityPerCase;
@property (nonatomic) NSNumber* quantityUnits;
@property (nonatomic) NSNumber* quantityTrigger;

@property (nonatomic) NSString* categoryMainId;
@property (nonatomic) NSString* categorySubId;
@property (nonatomic) NSString* categoryProductId;


#pragma mark - Logic
- (BOOL) isValid;
- (void) setValuesFromCategoryProduct:(CategoryProduct*)categoryProduct;
- (BOOL) updateBatches:(NSInteger)update;
- (BFOrderStatusIndex) orderStatus;
+ (NSInteger)defaultQuantityTrigger;
+ (NSInteger)countUserProductsForSupplier:(NSString*)supplier;

#pragma mark - Keys
+ (NSString*)categoryMainIdKey;
+ (NSString*)categorySubIdKey;
+ (NSString*)categoryProductIdKey;
+ (NSString*)supplierKey;

@end
