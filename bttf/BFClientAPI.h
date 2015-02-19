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


typedef void (^BFLoginBlock)(NSError* error);
typedef void (^BFSuccessObjectsBlock)(NSArray *objects);
typedef void (^BFFailureBlock)(NSError* error);
typedef void (^BFSuccessObjectBlock)(id object);


@interface BFClientAPI : NSObject

//- (instancetype)initWithBaseURL:(NSString *)baseURL;

/**
 Singleton object.
 */
+ (BFClientAPI *)sharedAPI;


#pragma mark - Preload
- (void)preloadGenericData;
- (void)preloadUserSpecificData;

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

- (void)createCategoryMain:(CategoryMain *)category
               withSuccess:(BFSuccessObjectBlock)success
                   failure:(BFFailureBlock)failure;

- (void)createCategorySub:(CategorySub *)category
              withSuccess:(BFSuccessObjectBlock)success
                  failure:(BFFailureBlock)failure;

- (void)createCategoryProduct:(CategoryProduct *)category
                  withSuccess:(BFSuccessObjectBlock)success
                      failure:(BFFailureBlock)failure;
#pragma mark - Products
- (void)getUserProductsWithParameters:(NSDictionary *)parameters
                      withSuccess:(BFSuccessObjectsBlock)success
                          failure:(BFFailureBlock)failure;

- (void)createUserProduct:(UserProduct *)userProduct
              withSuccess:(BFSuccessObjectBlock)success
                  failure:(BFFailureBlock)failure;

- (void)updateUserProduct:(UserProduct *)userProduct
              withSuccess:(BFSuccessObjectBlock)success
                  failure:(BFFailureBlock)failure;

#ifdef DEBUG
#pragma mark - Admin
- (void)processCategoriesFromCSV;
#endif

@end