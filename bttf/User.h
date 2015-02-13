//
//  User.h
//  BackToTheFarm
//
//  Created by Siddhant Dange on 1/6/15.
//  Copyright (c) 2015 Siddhant Dange. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface User : MTLModel <MTLJSONSerializing>

@property (nonatomic) NSString* objectId;
@property (nonatomic, strong) NSString *username, *token;
@property (nonatomic, strong) NSMutableDictionary *meatData;
@property (nonatomic, assign) BOOL firstYieldTestComplete;
@property (nonatomic, assign) float totalWeight;


-(void)createUserWithUsername:(NSString*)username password:(NSString*)password email:(NSString*)email completion:(void(^)(NSDictionary*,NSError*))completion;
-(void)loginUserWithUsername:(NSString*)username password:(NSString*)password completion:(void(^)(NSDictionary*,NSError*))completion;
-(NSDictionary*)returnUserLoginData;
-(void)writeUserLoginData:(NSDictionary*)userData;
-(void)syncMeatWeightSuccess:(void(^)(void))success failure:(void(^)(NSString*))failure;
-(void)syncPercSuccess:(void(^)(void))success failure:(void(^)(NSString*))failure;
-(void)readMeatFromCloud:(void(^)(void))success failure:(void(^)(NSString*))failure;

-(void)setYieldTestFromMeatData;
-(NSDictionary*)getPercData;
-(void)setTotalWeight;

-(BOOL)loadMeatFromFile;
-(BOOL)loadPercsFromFile;

+(instancetype)sharedInstance;

@end
