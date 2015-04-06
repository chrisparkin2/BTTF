//
//  BFProduct.m
//  bttf
//
//  Created by Admin on 2/11/15.
//  Copyright (c) 2015 bttf. All rights reserved.
//

#import "UserProduct.h"
#import "CategoryMain.h"
#import "CategorySub.h"
#import "CategoryProduct.h"
#import "User.h"
#import "BFClientAPI.h"
#import "BFCache.h"


@implementation UserProduct

#pragma mark - Logic
- (instancetype)init {
    
    self = [super init];
    if (self) {
        _quantityBulk = @(0);
        _quantityTrigger = @(defaultTrigger);
    }
    return self;
}

- (BOOL) isValid {
    if (!self.userId || !self.price || !self.name || !self.quantityBulk) return NO;
    return YES;
}

- (void)setValuesFromCategoryProduct:(CategoryProduct*)categoryProduct {
    
    self.categoryProductId = categoryProduct.objectId;
    self.categorySubId = categoryProduct.categorySubId;
    self.categoryMainId = categoryProduct.categoryMainId;
}

- (BOOL)updateBatches:(NSInteger)update {
    
    // Don't allow negative batches
    NSInteger newBatches = [self.quantityBulk integerValue] + update;
    if (newBatches < 0) return NO;
    
    // Set new batch quantity
    self.quantityBulk = @(newBatches);
    
    // Update total units
    NSInteger unitsToAdd = update * [self.quantityPerCase integerValue];
    self.quantityUnits = @([self.quantityUnits integerValue] + unitsToAdd);
    
    return YES;
}

- (BFOrderStatusIndex) orderStatus {
    if ([self.quantityUnits integerValue] <= [self.quantityTrigger integerValue]) {
        return BFOrderStatusCritical;
    }
    else return BFOrderStatusOK;
}

+ (NSInteger)defaultQuantityTrigger {
    return defaultTrigger;
}

+ (NSInteger)countUserProductsForSupplier:(NSString*)supplier {
    
    NSArray* userProducts = [[BFCache sharedCache] objectsForClass:[UserProduct class]];
    NSPredicate* supplierPredicate = [NSPredicate predicateWithFormat:@"%K like %@", @"supplier", supplier];
    NSArray* filtered =  [userProducts filteredArrayUsingPredicate:supplierPredicate];
    
    
    return filtered.count;
}

#pragma mark MTLJSONSerializing
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"objectId" : @"_id",
             @"userId" : @"user_id",
             @"name" : @"name",
             @"price" : @"price",
             @"supplier" : @"supplier",
             @"quantityBulk" : @"quantity_bulk",
             @"quantityPerCase" : @"quantity_per_case",
             @"quantityUnits" : @"quantity_units",
             @"quantityTrigger" : @"quantity_trigger",
             @"categoryMainId" : @"_category_main_id",
             @"categorySubId" : @"_category_sub_id",
             @"categoryProductId" : @"_category_product_id"
             };
}


#pragma mark - Keys
+ (NSString*)categoryMainIdKey {
    return @"categoryMainId";
}
+ (NSString*)categorySubIdKey {
    return @"categorySubId";
}
+ (NSString*)categoryProductIdKey {
    return @"categoryProductId";
}

+ (NSString*)supplierKey {
    return @"supplier";
}





@end
