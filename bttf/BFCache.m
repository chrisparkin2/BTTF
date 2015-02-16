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
- (NSMutableArray*)objectsForClass:(Class)class {
    NSMutableArray* objects;
    NSDictionary *attributes = [self attributesForApp];
    if (attributes) objects = [attributes objectForKey:NSStringFromClass(class)];
    
    if (objects) return objects;
    
    return nil;
}

- (void)setObjects:(NSArray*)objects forClass:(Class)class {
    if (objects) {
        NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:[self attributesForApp]];
        [attributes setObject:objects forKey:NSStringFromClass(class)];
        [self setAttributesForApp:attributes];
    }
    
}

#pragma mark - Categories
- (NSMutableArray*)categoriesMain {
    NSMutableArray* categoriesMain;
    NSDictionary *attributes = [self attributesForApp];
    if (attributes) categoriesMain = [attributes objectForKey:[BFCache categoriesMainKey]];

    if (categoriesMain) return categoriesMain;
    
    return nil;
}
- (void)setCategoriesMain:(NSMutableArray*)categoriesMain {
    if (categoriesMain) {
        NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:[self attributesForApp]];
        [attributes setObject:categoriesMain forKey:[BFCache categoriesMainKey]];
        [self setAttributesForApp:attributes];
    }
}

- (NSMutableArray*)categoriesSub {
    NSMutableArray* categoriesSub;
    NSDictionary *attributes = [self attributesForApp];
    if (attributes) categoriesSub = [attributes objectForKey:[BFCache categoriesSubKey]];
    
    if (categoriesSub) return categoriesSub;
    
    return nil;
}
- (void)setCategoriesSub:(NSMutableArray*)categoriesSub {
    if (categoriesSub) {
        NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:[self attributesForApp]];
        [attributes setObject:categoriesSub forKey:[BFCache categoriesSubKey]];
        [self setAttributesForApp:attributes];
    }
}

- (NSMutableArray*)categoriesProduct {
    NSMutableArray* categoriesProduct;
    NSDictionary *attributes = [self attributesForApp];
    if (attributes) categoriesProduct = [attributes objectForKey:[BFCache categoriesProductKey]];
    
    if (categoriesProduct) return categoriesProduct;
    
    return nil;
}
- (void)setCategoriesProduct:(NSMutableArray*)categoriesProduct {
    if (categoriesProduct) {
        NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:[self attributesForApp]];
        [attributes setObject:categoriesProduct forKey:[BFCache categoriesProductKey]];
        [self setAttributesForApp:attributes];
    }
}


#pragma mark - Keys
+ (NSString *)keyForApp {
    return [NSString stringWithFormat:@"app"];
}

+ (NSString *)categoriesMainKey {
    return [NSString stringWithFormat:@"categoriesMain"];
}

+ (NSString *)categoriesSubKey {
    return [NSString stringWithFormat:@"categoriesSub"];
}

+ (NSString *)categoriesProductKey {
    return [NSString stringWithFormat:@"categoriesProduct"];
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
