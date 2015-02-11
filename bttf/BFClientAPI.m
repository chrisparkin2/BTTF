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

NSString *const API_URL = @"https://1f70d9e9.ngrok.com/";
//NSString *const API_URL = @"http://backtothefarm.herokuapp.com";


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

#pragma mark - Base Call -

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

#pragma mark - Category
- (void)getCategoryWithParameters:(NSDictionary *)parameters
        withSuccess:(BFCategoryBlock)success
         failure:(BFFailureBlock)failure
{
    
    [self postPath:[NSString stringWithFormat:@"category/read"] parameters:parameters responseModel:[NSDictionary class] success:^(id response) {
        if(success)
        {
            NSError *error = nil;
            NSArray* data = [response objectForKey:@"data"];
            NSArray *categories = [MTLJSONAdapter modelsOfClass:BFCategory.class fromJSONArray:data error:&error];
            success(categories);
        }
    } failure:^(NSError *error, NSInteger statusCode) {
        if(failure)
        {
            failure(error);
        }
    }];
}

- (void)createCategory:(BFCategory *)category
        withSuccess:(BFSuccessBlock)success
            failure:(BFFailureBlock)failure
{
    NSDictionary *JSONDictionary = [MTLJSONAdapter JSONDictionaryFromModel:category];
    
    [self postPath:[NSString stringWithFormat:@"category/create"] parameters:JSONDictionary responseModel:[NSDictionary class] success:^(id response) {
        if(success)
        {            
            success();
        }
    } failure:^(NSError *error, NSInteger statusCode) {
        if(failure)
        {
            failure(error);
        }
    }];
}

#ifdef DEBUG
#pragma mark - Admin
//- (void)processCategoriesFromCSV {
//    
//    // Load the file
//    NSString* path = [[NSBundle mainBundle] pathForResource:@"categories
//                                                     ofType:@"csv"];
//    NSString *fh = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
//    if (!fh) return;
//    
//    
//    
//    // create dictionaries of all the level_0 objects
//    NSMutableArray* level_0 = [NSMutableArray new];
//    NSMutableArray* level_1 = [NSMutableArray new];
//    NSMutableArray* level_2 = [NSMutableArray new];
//
//    
//    // Parse the files into Arrays of Category objects
//    BOOL isFirst = YES;
//    for (NSString *line in [fh componentsSeparatedByString:@"\n"]) {
//        
//        if (isFirst) { isFirst = NO; return; } // skip first line
//        
//        [line stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
//        if ([line length] > 0) {
//            NSArray *lines = [line componentsSeparatedByString: @","];
//            
//            NSMutableDictionary
//            
//            if (lines[0]) {
//                [level_0 setObject:lines[0] forKey:@"name"];
//                [level_0 setObject:nil forKey:@"parent"];
//            }
//            else {
//                
//            }
//            
//            
//            lines[0] ? [level_0 setObject:<#(id)#> forKey:<#(id<NSCopying>)#>] : [feeds addObject:@""];
//            lines[1] ? [feedsIds addObject:lines[1]] : [feedsIds addObject:@""];
//            lines[2] ? [feedsNames addObject:lines[2]] : [feedsNames addObject:@""];
//        }
//        
//        break;
//    }
//    
//    
//   
//    
//}


#endif


@end