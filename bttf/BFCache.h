//
//  FSCache.h
//  bttf
//
//  Created by Admin on 1/23/15.
//  Copyright (c) 2015 Ramsel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface BFCache : NSObject

+ (id)sharedCache;

- (void)clear;

#pragma mark - Categories
- (NSMutableArray*)categoriesMain;
- (void)setCategoriesMain:(NSMutableArray*)categoriesMain;

- (NSMutableArray*)categoriesSub;
- (void)setCategoriesSub:(NSMutableArray*)categoriesSub;

- (NSMutableArray*)categoriesProduct;
- (void)setCategoriesProduct:(NSMutableArray*)categoriesProduct;

@end
