//
//  BFClientAPI.h
//  bttf
//
//  Created by Admin on 2/10/15.
//  Copyright (c) 2015 bttf. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import "CategoryMain.h"


typedef void(^BFLoginBlock)(NSError* error);
typedef void(^BFCategoryBlock)(NSArray *categories);
typedef void (^BFFailureBlock)(NSError* error);
typedef void (^BFSuccessBlock)();

//typedef void (^InstagramTagsBlock)(NSArray *tags, InstagramPaginationInfo *paginationInfo);

@interface BFClientAPI : NSObject

//- (instancetype)initWithBaseURL:(NSString *)baseURL;

/**
 Singleton object.
 */
+ (BFClientAPI *)sharedAPI;

///**
// Fetches topics. Array of @c NPTopic objects.
// */
//- (NSURLSessionDataTask *)fetchTopicsOnSuccess:(void (^)(NSURLSessionDataTask *task, NSArray *topics))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

#pragma mark - Category
- (void)getCategoryWithParameters:(NSDictionary *)parameters
                      withSuccess:(BFCategoryBlock)success
                          failure:(BFFailureBlock)failure;

- (void)createCategory:(CategoryMain *)category
            withSuccess:(BFSuccessBlock)success
               failure:(BFFailureBlock)failure;

#pragma mark - Products
- (void)getProductsWithParameters:(NSDictionary *)parameters
                        withSuccess:(BFCategoryBlock)success
                          failure:(BFFailureBlock)failure;
@end