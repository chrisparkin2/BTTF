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

#pragma mark - Main
- (NSArray*)objectsForClass:(Class)class;
- (void)setObjects:(NSArray*)objects forClass:(Class)class;
- (void)addObject:(id)object forClass:(Class)class;
- (void)updateObject:(id)object forClass:(Class)class;

@end
