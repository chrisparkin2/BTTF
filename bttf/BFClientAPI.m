//
//  BFClientAPI.m
//  bttf
//
//  Created by Admin on 2/10/15.
//  Copyright (c) 2015 bttf. All rights reserved.
//

#import "BFClientAPI.h"
#import "AFNetworking.h"
#import "User.h"
#import "BFCache.h"

//NSString *const API_URL = @"https://1f70d9e9.ngrok.com/";
NSString *const API_URL = @"http://backtothefarm.herokuapp.com";


#define kData @"data"
#define kKeyAccessToken @"token"


@interface BFClientAPI ()
{
    dispatch_queue_t mBackgroundQueue;
}

@property (nonatomic, strong) AFHTTPRequestOperationManager *operationManager;

@end

@implementation BFClientAPI


#pragma mark - Singleton

+ (BFClientAPI *)sharedAPI
{
    static BFClientAPI *sharedClientAPI;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClientAPI = [[BFClientAPI alloc] init];

    });
    
    return sharedClientAPI;
}


#pragma mark - Lifecycle
- (id)init {
    if (self = [super init])
    {
       
        NSURL* baseURL = [NSURL URLWithString:API_URL];
        self.operationManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseURL];
        self.operationManager.responseSerializer = [[AFJSONResponseSerializer alloc] init];

        mBackgroundQueue = dispatch_queue_create("background", NULL);
        
    }
    return self;
}

#pragma mark - Base Call

- (void)getPath:(NSString *)path
     parameters:(NSDictionary *)parameters
  responseModel:(Class)modelClass
        success:(void (^)(NSDictionary *responseObject))success
        failure:(void (^)(NSError* error, NSInteger statusCode))failure
{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [params setObject:[User sharedInstance].token forKey:kKeyAccessToken];

    NSString *percentageEscapedPath = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [self.operationManager GET:percentageEscapedPath
                    parameters:params
                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                           NSDictionary *responseDictionary = (NSDictionary *)responseObject;
                        
                           success(responseDictionary);
                           
                       }
                       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                           failure(error,[[operation response] statusCode]);
                       }];
}

- (void)postPath:(NSString *)path
      parameters:(NSDictionary *)parameters
   responseModel:(Class)modelClass
         success:(void (^)(NSDictionary *responseObject))success
         failure:(void (^)(NSError* error, NSInteger statusCode))failure
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [params setObject:[User sharedInstance].token forKey:kKeyAccessToken];

    [self.operationManager POST:path
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            NSDictionary *responseDictionary = (NSDictionary *)responseObject;
                            
                            if ([[responseObject objectForKey:@"status"] isEqual:@(200)]) {
                                
                                NSString* message = [responseObject objectForKey:@"message"];
                                failure([self errorWithMessage:message],[[operation response] statusCode]);
                            }
                            
                            success(responseDictionary);
                        }
                        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            NSLog(@"operation.responseString = %@",operation.responseString);
                            
                            
                            failure(error,[[operation response] statusCode]);
                        }];
}


- (void)deletePath:(NSString *)path
        parameters:(NSDictionary *)parameters
     responseModel:(Class)modelClass
           success:(void (^)(void))success
           failure:(void (^)(NSError* error, NSInteger statusCode))failure
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [params setObject:[User sharedInstance].token forKey:kKeyAccessToken];

    
    [self.operationManager DELETE:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success();
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error,[[operation response] statusCode]);
        }
    }];
}

#pragma mark - Base Operations
- (void)saveObject:(id)object
       objectClass:(Class)objectClass
        objectPath:(NSString*)objectPath
               withSuccess:(BFSuccessBlock)success
                   failure:(BFFailureBlock)failure
{
    NSDictionary *JSONDictionary = [MTLJSONAdapter JSONDictionaryFromModel:object];
    
    NSString* path = [NSString stringWithFormat:@"%@/create",objectPath];
    
    [self postPath:path parameters:JSONDictionary responseModel:[NSDictionary class] success:^(id response) {
        if(success)
        {
            // Add to cache
            [[BFCache sharedCache] addObject:object forClass:objectClass];
        
            success();
        }
    } failure:^(NSError *error, NSInteger statusCode) {
        if(failure)
        {
            failure(error);
        }
    }];
}


- (void)getObjectsWithParameters:(NSDictionary *)parameters
                     objectClass:(Class)objectClass
                      objectPath:(NSString*)objectPath
                        withSuccess:(BFSuccessObjectsBlock)success
                            failure:(BFFailureBlock)failure
{
    
    // Check if cached
    if ([[BFCache sharedCache] objectsForClass:[objectClass class]]) {
        NSArray* objects = [self filteredObjects:[[BFCache sharedCache] objectsForClass:[objectClass class]] parameters:parameters];
        success(objects);
        return;
    }
    
    // Service call
    NSString* path = [NSString stringWithFormat:@"%@/read",objectPath];
    
    NSDictionary* parametersJSON = [self JSONKeysFromObjectKeys:parameters objectClass:objectClass];
    
    [self postPath:path parameters:parametersJSON responseModel:[NSDictionary class] success:^(id response) {
        if(success)
        {
            NSError *error = nil;
            NSArray* data = [response objectForKey:@"data"];
            NSArray *objects = [MTLJSONAdapter modelsOfClass:objectClass fromJSONArray:data error:&error];
            
            
            // callback
            success(objects);
        }
    } failure:^(NSError *error, NSInteger statusCode) {
        if(failure)
        {
            failure(error);
        }
    }];
}


#pragma mark - Preload
- (void)preloadGenericData {

}

- (void)preloadUserSpecificData {
    // need user token for access
    [self getCategoriesMainWithParameters:nil withSuccess:^(NSArray *objects) {
        if (objects) [[BFCache sharedCache] setObjects:objects forClass:[CategoryMain class]];
    } failure:nil];
    
    [self getCategoriesSubWithParameters:nil withSuccess:^(NSArray *objects) {
        if (objects) [[BFCache sharedCache] setObjects:objects forClass:[CategorySub class]];
    } failure:nil];
    
    [self getCategoriesProductWithParameters:nil withSuccess:^(NSArray *objects) {
        if (objects) [[BFCache sharedCache] setObjects:objects forClass:[CategoryProduct class]];
    } failure:nil];
    
    NSLog(@"[User sharedInstance] = %@",[User sharedInstance]);
    
    NSDictionary* parameters = @{ @"userId" : [User sharedInstance].objectId };
    [self getUserProductsWithParameters:parameters withSuccess:^(NSArray *objects) {
        if (objects) [[BFCache sharedCache] setObjects:objects forClass:[UserProduct class]];
    } failure:nil];
}

#pragma mark - Category
- (void)getCategoriesMainWithParameters:(NSDictionary *)parameters
        withSuccess:(BFSuccessObjectsBlock)success
         failure:(BFFailureBlock)failure
{
    
    [self getObjectsWithParameters:parameters objectClass:CategoryMain.class objectPath:[self categoryMain] withSuccess:success failure:failure];
}

- (void)getCategoriesSubWithParameters:(NSDictionary *)parameters
                            withSuccess:(BFSuccessObjectsBlock)success
                                failure:(BFFailureBlock)failure
{
    
    [self getObjectsWithParameters:parameters objectClass:CategorySub.class objectPath:[self categorySub] withSuccess:success failure:failure];
}

- (void)getCategoriesProductWithParameters:(NSDictionary *)parameters
                            withSuccess:(BFSuccessObjectsBlock)success
                                failure:(BFFailureBlock)failure
{
    

    [self getObjectsWithParameters:parameters objectClass:CategoryProduct.class objectPath:[self categoryProduct] withSuccess:success failure:failure];
}



- (void)createCategoryMain:(CategoryMain *)category
        withSuccess:(BFSuccessBlock)success
            failure:(BFFailureBlock)failure
{
    [self saveObject:category objectClass:CategoryMain.class objectPath:[self categoryMain]  withSuccess:success failure:failure];
}

- (void)createCategorySub:(CategorySub *)category
               withSuccess:(BFSuccessBlock)success
                   failure:(BFFailureBlock)failure
{
    [self saveObject:category objectClass:CategorySub.class objectPath:[self categorySub] withSuccess:success failure:failure];
}

- (void)createCategoryProduct:(CategoryProduct *)category
              withSuccess:(BFSuccessBlock)success
                  failure:(BFFailureBlock)failure
{
    [self saveObject:category objectClass:CategoryProduct.class objectPath:[self categoryProduct] withSuccess:success failure:failure];
}

#pragma mark - UserProduct
- (void)getUserProductsWithParameters:(NSDictionary *)parameters
                            withSuccess:(BFSuccessObjectsBlock)success
                                failure:(BFFailureBlock)failure
{
    [self getObjectsWithParameters:parameters objectClass:UserProduct.class objectPath:[self userProduct] withSuccess:success failure:failure];
}

- (void)createUserProduct:(UserProduct *)userProduct
                  withSuccess:(BFSuccessBlock)success
                      failure:(BFFailureBlock)failure
{
    [self saveObject:userProduct objectClass:UserProduct.class objectPath:[self userProduct] withSuccess:success failure:failure];
}

#pragma mark - Object Paths
- (NSString*)categoryMain {
    return @"category_main";
}

- (NSString*)categorySub {
    return @"category_sub";
}

- (NSString*)categoryProduct {
    return @"category_product";
}

- (NSString*)userProduct {
    return @"user_product";
}

#pragma mark - Utils
- (NSDictionary*)JSONKeysFromObjectKeys:(NSDictionary*)objectKeys objectClass:(Class)objectClass {
    // Convert object keys to JSON keys
    MTLJSONAdapter* jsonAdapter = [[MTLJSONAdapter alloc] initWithModel:[objectClass new]];
    NSMutableDictionary* keysJSON = [[NSMutableDictionary alloc] initWithCapacity:objectKeys.count];
    [objectKeys enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSString* keyJSON = [jsonAdapter JSONKeyPathForPropertyKey:key];
        [keysJSON setValue:obj forKey:keyJSON];
    }];
    
    return [keysJSON copy];
}


#pragma mark - Error
- (NSError*)errorWithMessage:(NSString*)message {
    
    NSMutableDictionary* details = [NSMutableDictionary dictionary];
    [details setValue:message forKey:NSLocalizedDescriptionKey];
    return [NSError errorWithDomain:@"network" code:200 userInfo:details];

}


#pragma mark - Cache
- (NSArray*)filteredObjects:(NSArray*)objects parameters:(NSDictionary*)parameters {
    
    // TODO: This filtering process will not work for parameters that aren't simple equality predicates
    
    // Enumerate predicates
    __block NSMutableArray* predicates = [[NSMutableArray alloc] initWithCapacity:parameters.count];;
    [parameters enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K like %@", key, obj];
        [predicates addObject:predicate];
    }];
    NSPredicate* combinedPredicates = [NSCompoundPredicate andPredicateWithSubpredicates:predicates];
    

    // Apply
    NSArray *filtered = [objects filteredArrayUsingPredicate:combinedPredicates];
    
    
    return  filtered;
}

#ifdef DEBUG
#pragma mark - Admin
- (void)processCategoriesFromCSV {
        
    // Get all existsing categories
    __block NSMutableArray* categoriesMain = [NSMutableArray new];
    __block NSMutableArray* categoriesSub = [NSMutableArray new];
    __block NSMutableArray* categoriesProduct = [NSMutableArray new];
    __block NSError *groupError;
    
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_enter(group);
    [self getCategoriesMainWithParameters:nil withSuccess:^(NSArray *objects) {
        [categoriesMain addObjectsFromArray:objects];
        dispatch_group_leave(group);
    } failure:^(NSError *error) {
        groupError = error;
        dispatch_group_leave(group);
    }];
    
    dispatch_group_enter(group);
    [self getCategoriesSubWithParameters:nil withSuccess:^(NSArray *objects) {
        [categoriesSub addObjectsFromArray:objects];
        dispatch_group_leave(group);
    } failure:^(NSError *error) {
        groupError = error;
        dispatch_group_leave(group);
    }];
    
    dispatch_group_enter(group);
    [self getCategoriesProductWithParameters:nil withSuccess:^(NSArray *objects) {
        [categoriesProduct addObjectsFromArray:objects];
        dispatch_group_leave(group);
    } failure:^(NSError *error) {
        groupError = error;
        dispatch_group_leave(group);
    }];
    
    dispatch_group_notify(group,dispatch_get_main_queue(),^{
        
        if (groupError) {
            NSLog(@"groupError = %@",groupError);
            return;
        }
        
        NSLog(@"categoriesMain = %@",categoriesMain);
        NSLog(@"categoriesSub = %@",categoriesSub);
        NSLog(@"categoriesProduct = %@",categoriesProduct);
        
        
        NSMutableSet* categoriesMainToSave = [NSMutableSet new];
        NSMutableSet* categoriesSubToSave = [NSMutableSet new];
        NSMutableSet* categoriesProductToSave = [NSMutableSet new];

        // Load the file
        NSString* path = [[NSBundle mainBundle] pathForResource:@"categories"
                                                         ofType:@"csv"];
        NSString *fh = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
        if (!fh) return;
        
        // Parse the files into Arrays of Category objects
        BOOL isFirst = YES;
        for (NSString *line in [fh componentsSeparatedByString:@"\n"]) {
            
            NSLog(@"line = %@",line);
            
            if (isFirst) { isFirst = NO; continue; } // skip first line
            
            [line stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
            if ([line length] > 0) {
                NSArray *lines = [line componentsSeparatedByString: @","];
                
                // Create category objects
                CategoryMain* categoryMain = [CategoryMain new];
                categoryMain.name = lines[0];
                if([self hasCategoryName:lines[0] categories:categoriesMain]) categoryMain = [self hasCategoryName:lines[0] categories:categoriesMain];

                CategorySub* categorySub = [CategorySub new];
                categorySub.name = lines[1];
                categorySub.categoryMainId = categoryMain.objectId;
                if([self hasCategoryName:lines[1] categories:categoriesSub]) categorySub = [self hasCategoryName:lines[1] categories:categoriesSub];
                
                CategoryProduct* categoryProduct = [CategoryProduct new];
                categoryProduct.name = lines[2];
                categoryProduct.categoryMainId = categoryMain.objectId;
                categoryProduct.categorySubId = categorySub.objectId;
                if([self hasCategoryName:lines[2] categories:categoriesProduct]) categoryProduct = [self hasCategoryName:lines[2] categories:categoriesProduct];


                // Add them to save array
                if (lines[0] && ![self hasCategoryName:lines[0] categories:categoriesMain]) [categoriesMainToSave addObject:categoryMain];
                if (lines[1] && ![self hasCategoryName:lines[1] categories:categoriesSub]) [categoriesSubToSave addObject:categorySub];
                if (lines[2] && ![self hasCategoryName:lines[2] categories:categoriesProduct]) [categoriesProductToSave addObject:categoryProduct];
            }
            
        }
        
        NSLog(@"categoriesMainToSave = %@",categoriesMainToSave);
        NSLog(@"categoriesSubToSave = %@",categoriesSubToSave);
        NSLog(@"categoriesProductToSave = %@",categoriesProductToSave);
        
        // Save these concurrently within each category, but serially overall
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{ // 1

//            dispatch_group_t groupMain = dispatch_group_create();
//            
//            NSArray* categoriesMainToSaveArray = [categoriesMainToSave allObjects];
//            [categoriesMainToSaveArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//                
//                dispatch_group_enter(groupMain);
//                CategoryMain* main = (CategoryMain*)obj;
//                [[BFClientAPI sharedAPI] createCategoryMain:main withSuccess:^{
//                    dispatch_group_leave(groupMain);
//
//                } failure:^(NSError *error) {
//                    NSLog(@"error = %@",error);
//                    dispatch_group_leave(groupMain);
//
//                }];
//            }];
//            dispatch_group_wait(groupMain, DISPATCH_TIME_FOREVER); // 5

            
            
            
//            // Save all the categories
//            dispatch_group_t groupSub = dispatch_group_create();
//            
//            NSArray* categoriesSubToSaveArray = [categoriesSubToSave allObjects];
//            [categoriesSubToSaveArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//                dispatch_group_enter(groupSub);
//                CategorySub* sub = (CategorySub*)obj;
//                [[BFClientAPI sharedAPI] createCategorySub:sub withSuccess:^{
//                    dispatch_group_leave(groupSub);
//
//                } failure:^(NSError *error) {
//                    NSLog(@"error = %@",error);
//                    dispatch_group_leave(groupSub);
//
//                }];
//                
//            }];
//            dispatch_group_wait(groupSub, DISPATCH_TIME_FOREVER); // 5
//
//            
//
            dispatch_group_t groupProduct = dispatch_group_create();

            NSArray* categoriesProductToSaveArray = [categoriesProductToSave allObjects];
            [categoriesProductToSaveArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                dispatch_group_enter(groupProduct);

                CategoryProduct* product = (CategoryProduct*)obj;
                [[BFClientAPI sharedAPI] createCategoryProduct:product withSuccess:^{
                    dispatch_group_leave(groupProduct);

                } failure:^(NSError *error) {
                    NSLog(@"error = %@",error);
                    dispatch_group_leave(groupProduct);

                }];
                
            }];
            dispatch_group_wait(groupProduct, DISPATCH_TIME_FOREVER); // 5

        });
    });
}

- (id) hasCategoryName:(NSString*)categoryName categories:(NSArray*)categories {
    
    __block id found;
    
    [categories enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        NSDictionary *JSONDictionary = [MTLJSONAdapter JSONDictionaryFromModel:obj];
        NSString* nameToCheck = [JSONDictionary objectForKey:@"name"];
        
        if ([nameToCheck isKindOfClass:NSString.class] &&
            [nameToCheck isEqualToString:categoryName]) {
            found = obj;
            *stop = YES;
            return;
        }
    }];
    
    return found;
}

#endif


@end