//
//  BFClientAPI.h
//  bttf
//
//  Created by Admin on 2/10/15.
//  Copyright (c) 2015 bttf. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import "CategoryMain.h"
#import "CategorySub.h"
#import "CategoryProduct.h"
#import "UserProduct.h"


typedef void(^BFLoginBlock)(NSError* error);
typedef void(^BFSuccessObjectsBlock)(NSArray *objects);
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
- (void)getCategoriesMainWithParameters:(NSDictionary *)parameters
                      withSuccess:(BFSuccessObjectsBlock)success
                          failure:(BFFailureBlock)failure;

- (void)getCategoriesSubWithParameters:(NSDictionary *)parameters
                           withSuccess:(BFSuccessObjectsBlock)success
                               failure:(BFFailureBlock)failure;

- (void)getCategoriesProductWithParameters:(NSDictionary *)parameters
                               withSuccess:(BFSuccessObjectsBlock)success
                                   failure:(BFFailureBlock)failure;

- (void)createCategory:(CategoryMain *)category
            withSuccess:(BFSuccessBlock)success
               failure:(BFFailureBlock)failure;

- (void)createCategorySub:(CategorySub *)category
              withSuccess:(BFSuccessBlock)success
                  failure:(BFFailureBlock)failure;

- (void)createCategoryProduct:(CategoryProduct *)category
                  withSuccess:(BFSuccessBlock)success
                      failure:(BFFailureBlock)failure;
#pragma mark - Products
- (void)getUserProductsWithParameters:(NSDictionary *)parameters
                      withSuccess:(BFSuccessObjectsBlock)success
                          failure:(BFFailureBlock)failure;

- (void)createUserProduct:(UserProduct *)userProduct
              withSuccess:(BFSuccessBlock)success
                  failure:(BFFailureBlock)failure;

#ifdef DEBUG
#pragma mark - Admin
- (void)processCategoriesFromCSV;
#endif

@end