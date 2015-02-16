//
//  FSCache.m
//  bttff
//
//  Created by Admin on 1/23/15.
//  Copyright (c) 2015 Ramsel. All rights reserved.
//

#import "BFCache.h"

@interface BFCache()

@property (nonatomic, strong) NSCache *cache;

@end

@implementation BFCache

#pragma mark - Initialization

+ (id)sharedCache {
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}




- (id)init {
    self = [super init];
    if (self) {
        self.cache = [[NSCache alloc] init];
    }
    
    return self;
}

#pragma mark - WSCache

- (void)clear {
    
    [self.cache removeAllObjects];
}



#pragma mark - Main
- (NSArray*)objectsForClass:(Class)class {
    NSMutableArray* objects;
    NSDictionary *attributes = [self attributesForApp];
    if (attributes) objects = [attributes objectForKey:NSStringFromClass(class)];
    
    if (objects) return [objects copy];
    
    return nil;
}

- (void)setObjects:(NSArray*)objects forClass:(Class)class {
    if (objects) {
        NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:[self attributesForApp]];
        [attributes setObject:objects forKey:NSStringFromClass(class)];
        [self setAttributesForApp:attributes];
    }
    
}

- (void)addObject:(id)object forClass:(Class)class {
    NSMutableArray* objects = [[self objectsForClass:class] mutableCopy];
    if (objects && [object isKindOfClass:class]) {
        [objects addObject:object];
    }
    [self setObjects:objects forClass:class];
}


#pragma mark - Keys
+ (NSString *)keyForApp {
    return [NSString stringWithFormat:@"app"];
}



#pragma mark - ()
- (NSDictionary *)attributesForApp {
    NSString *key = [BFCache keyForApp];
    return [self.cache objectForKey:key];
}

- (void)setAttributesForApp:(NSDictionary *)attributes  {
    NSString *key = [BFCache keyForApp];
    [self.cache setObject:attributes forKey:key];
}




@end
