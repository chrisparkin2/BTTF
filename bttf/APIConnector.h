//
//  APIConnector.h
//  BackToTheFarm
//
//  Created by Siddhant Dange on 1/5/15.
//  Copyright (c) 2015 Siddhant Dange. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;

@interface APIConnector : NSObject

/**
 Singleton object.
 */
+ (APIConnector *)sharedAPI;

-(void)updateMeat:(NSDictionary*)meatData WithCompletion:(void(^)(NSDictionary*))completion;
-(void)readMeatWithCompletion:(void(^)(NSDictionary*))completion;
-(void)createUserWithUsername:(NSString*)username password:(NSString*)password email:(NSString*)email completion:(void(^)(NSDictionary*,NSError*))completion;
-(void)loginUserWithUsername:(NSString*)username password:(NSString*)password completion:(void(^)(NSDictionary*, NSError*))completion;
-(void)becomeUser:(User*)user completion:(void(^)(NSDictionary*, NSError*))completion;
-(void)writeStringToFile:(NSString*)data withName:(NSString*)name;
-(NSString*)readStringToFile:(NSString*)name;


-(void)writeDictionaryToFile:(NSDictionary*)data withName:(NSString*)name;
-(NSDictionary*)readDictionaryFromFile:(NSString*)name;

@end
