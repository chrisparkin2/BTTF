//
//  APIConnector.h
//  BackToTheFarm
//
//  Created by Siddhant Dange on 1/5/15.
//  Copyright (c) 2015 Siddhant Dange. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIConnector : NSObject

-(void)updateMeat:(NSDictionary*)meatData WithCompletion:(void(^)(NSDictionary*))completion;
-(void)readMeatWithCompletion:(void(^)(NSDictionary*))completion;
-(void)createUserWithUsername:(NSString*)username password:(NSString*)password email:(NSString*)email completion:(void(^)(NSDictionary*))completion;
-(void)loginUserWithUsername:(NSString*)username password:(NSString*)password completion:(void(^)(NSDictionary*))completion;
-(void)writeStringToFile:(NSString*)data withName:(NSString*)name;
-(NSString*)readStringToFile:(NSString*)name;


-(void)writeDictionaryToFile:(NSDictionary*)data withName:(NSString*)name;
-(NSDictionary*)readDictionaryFromFile:(NSString*)name;

@end
