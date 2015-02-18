//
//  User.m
//  BackToTheFarm
//
//  Created by Siddhant Dange on 1/6/15.
//  Copyright (c) 2015 Siddhant Dange. All rights reserved.
//

#import "User.h"
#import "APIConnector.h"
#import "BFConstants.h"

#define TEST_MODE_NEW 1
#define TEST_MODE_SAVE 2

#define TEST_MODE TEST_MODE_NEW



static User *gInstance;

@interface User ()

@property (nonatomic, strong) NSMutableDictionary *percData;
//@property (nonatomic, strong) APIConnector *apiConnector;

@end

@implementation User

#pragma mark MTLJSONSerializing
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"objectId" : @"_id",
             @"username" : @"username"
             };
}

-(void)createUserWithUsername:(NSString*)username password:(NSString*)password email:(NSString*)email completion:(void(^)(NSDictionary*,NSError*))completion{
    [[APIConnector sharedAPI] createUserWithUsername:username password:password email:email completion:^(NSDictionary *data,NSError*error) {
        _token = data[@"data"][@"token_id"];
        _objectId = data[@"data"][@"objectId"];
        _username = data[@"data"][@"username"];
        completion(data,error);
    }];
}

-(void)loginUserWithUsername:(NSString*)username password:(NSString*)password completion:(void(^)(NSDictionary*,NSError*))completion{
    
    [[APIConnector sharedAPI] loginUserWithUsername:username password:password completion:^(NSDictionary *data,NSError*error) {
        _token = data[@"data"][@"token_id"];
        _objectId = data[@"data"][@"objectId"];
        _username = data[@"data"][@"username"];
        
        // Save in NSUserDefaults
        NSData *dataToArchive = [NSKeyedArchiver archivedDataWithRootObject:[User sharedInstance]];
        [[NSUserDefaults standardUserDefaults] setObject:dataToArchive forKey:kBFUserDefaultsCurrentUserKey];
        
        completion(data,error);
        
    }];
}

-(void)becomeUserWithCompletion:(void(^)(NSDictionary*,NSError*))completion{
    
    // Check NSUserDefaults
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kBFUserDefaultsCurrentUserKey];
    User *user = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    if (user) {
        
        [[APIConnector sharedAPI] becomeUser:user completion:^(NSDictionary *data,NSError*error) {
            
            if (data) {
                _token = data[@"data"][@"token_id"];
                _objectId = data[@"data"][@"objectId"];
                _username = data[@"data"][@"username"];
                
                completion(data,error);
            }
            else {
                completion(nil,nil);
            }
           
            
        }];
    }
    else {
        completion(nil,nil);
    }
    
}






-(void)setTotalWeight{
    _totalWeight = [self generateTotal:_meatData];
}

-(void)setYieldTestFromMeatData{
    _percData = [self generatePercData:_meatData];
    
    //store into local
    [self writePercDataToFile];
    [self writeMeatDataToFile];
    
    //store on cloud
    [self syncMeatWithCloudSuccess:^{
        [self readMeatFromCloud:nil failure:nil];
    } failure:nil];
    
}

-(void)syncMeatWeightSuccess:(void(^)(void))success failure:(void(^)(NSString*))failure{
    [self writeMeatDataToFile];
    [self syncMeatWithCloudSuccess:success failure:failure];
}

-(void)syncPercSuccess:(void(^)(void))success failure:(void(^)(NSString*))failure{
    [self writePercDataToFile];
    [self syncMeatWithCloudSuccess:success failure:failure];
}

-(void)syncMeatWithCloudSuccess:(void(^)(void))success failure:(void(^)(NSString*))failure{
    NSData *meatPlist = [NSPropertyListSerialization
                     dataWithPropertyList:_meatData
                     format:NSPropertyListXMLFormat_v1_0
                     options:kNilOptions
                     error:NULL];
    
    NSString *meatStr = [[NSString alloc] initWithData:meatPlist encoding:NSUTF8StringEncoding];
    NSData *percPlist = [NSPropertyListSerialization
                         dataWithPropertyList:_percData
                         format:NSPropertyListXMLFormat_v1_0
                         options:kNilOptions
                         error:NULL];
    
    NSString *percStr = [[NSString alloc] initWithData:percPlist encoding:NSUTF8StringEncoding];
    [[APIConnector sharedAPI] updateMeat:@{
                                @"meat_data" : meatStr,
                                @"perc_data" : percStr
                                }
               WithCompletion:^(NSDictionary *data) {
                   
        int statusCode = ((NSNumber*)data[@"status"]).intValue;
        if(statusCode == 100 && success){
            success();
        } else if(statusCode == 200 && failure){
            failure(data[@"message"]);
        }
    }];
}

-(void)readMeatFromCloud:(void(^)(void))success failure:(void(^)(NSString*))failure{
    [[APIConnector sharedAPI] readMeatWithCompletion:^(NSDictionary *data) {
        int statusCode = ((NSNumber*)data[@"status"]).intValue;
        if(statusCode == 100){
            _meatData = [NSPropertyListSerialization
                                  propertyListWithData:[data[@"meat_data"] dataUsingEncoding:NSUTF8StringEncoding]
                                  options:kNilOptions
                                  format:NULL
                                  error:NULL];
            
            _percData = [NSPropertyListSerialization
                                      propertyListWithData:[data[@"perc_data"] dataUsingEncoding:NSUTF8StringEncoding]
                                      options:kNilOptions
                                      format:NULL
                                      error:NULL];
            [self writeMeatDataToFile];
            [self writePercDataToFile];
            if(success){
                success();
            }
        } else if(statusCode == 200 && failure){
            NSLog(@"Error reading meat from cloud");
            if(failure){
                failure(data[@"message"]);
            }
        }
    }];
}

-(void)writePercDataToFile{
    [[APIConnector sharedAPI] writeDictionaryToFile:_percData withName:@"perc_data"];
}

-(void)writeMeatDataToFile{
    [[APIConnector sharedAPI] writeDictionaryToFile:_meatData withName:@"meat_data"];
}

-(NSDictionary*)getPercData{
    return _percData;
}

-(NSDictionary*)returnUserLoginData{
    NSDictionary *userData = [[APIConnector sharedAPI] readDictionaryFromFile:@"user_login_data"];
    return userData;
}

-(void)writeUserLoginData:(NSDictionary*)userData{
    [[APIConnector sharedAPI] writeDictionaryToFile:userData withName:@"user_login_data"];
}

#pragma -mark Meat Conversion

-(float)generateTotal:(NSDictionary*)meats{
    float total = 0.0f;
    
    if([meats objectForKey:@"Meat"]){
        for(NSString *key in meats){
            total += ((NSNumber*)meats[key]).floatValue;
        }
        
        return total;
    }
    
    for(NSString* key in meats){
        total += [self generateTotal:meats[key]];
    }
    
    return total;
}

-(NSMutableDictionary*)generatePercData:(NSMutableDictionary*)meats{
    float totalWeight = [self generateTotal:meats];
    NSMutableDictionary *percData = (NSMutableDictionary*)CFBridgingRelease(CFPropertyListCreateDeepCopy(kCFAllocatorDefault, (CFPropertyListRef)meats, kCFPropertyListMutableContainers));
    [self meatsToPerc:percData withTotalWeight:totalWeight];
    return percData;
}


-(void)meatsToPerc:(NSMutableDictionary*)meats withTotalWeight:(float)totalWeight{
    for(NSString *key in meats.allKeys){
        if([meats[key] isKindOfClass:[NSDictionary class]]){
            [self meatsToPerc:meats[key] withTotalWeight:totalWeight];
        } else{
            NSNumber *val = meats[key];
            float perc = val.floatValue / totalWeight;
            [meats setObject:@(perc) forKey:key];
        }
    }
}

-(BOOL)loadMeatFromFile{
    _meatData = [[APIConnector sharedAPI] readDictionaryFromFile:@"meat_data"].mutableCopy;
    _meatData = (NSMutableDictionary *)CFBridgingRelease(CFPropertyListCreateDeepCopy(kCFAllocatorDefault, (CFDictionaryRef)_meatData, kCFPropertyListMutableContainers));
    if (!_meatData) {
        _meatData = @{
                                           @"cow" : @{
                                                   @"Forequarter" : @{}.mutableCopy,
                                                   @"Hindquarter" : @{}.mutableCopy,
                                                }.mutableCopy,
                                           @"pig" : @{}.mutableCopy,
                                           @"sheep" : @{}.mutableCopy,
                                           @"goat" : @{}.mutableCopy
                                           }.mutableCopy;
        [[APIConnector sharedAPI] writeDictionaryToFile:_meatData withName:@"meat_data"];
        
    } else{
        _totalWeight = [self generateTotal:_meatData];
    }
    
    _firstYieldTestComplete = _meatData && _meatData.allKeys.count > 0 && [self checkIfFilled:_meatData];
    return _firstYieldTestComplete;
}

-(BOOL)loadPercsFromFile{
    _percData = [[APIConnector sharedAPI] readDictionaryFromFile:@"perc_data"].mutableCopy;
    _firstYieldTestComplete = _percData && _percData.allKeys.count > 0  && [self checkIfFilled:_percData];
    return _firstYieldTestComplete;
}

-(BOOL)checkIfFilled:(NSDictionary*)data{
    
    BOOL valid = NO;
    for(NSString *key in data.allKeys){
        if(valid){
            return valid;
        }
        
        if([data[key] isKindOfClass:[NSDictionary class]]){
            valid |= [self checkIfFilled:data[key]];
        } else{
            valid |= [data[key] isKindOfClass:[NSNumber class]];
        }
    }
    
    return valid;
}

#pragma -mark Singleton

+(instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gInstance = [[User alloc] init];
        
//        gInstance.apiConnector = [[APIConnector alloc] init];
        gInstance.percData = @{}.mutableCopy;
    });

    
    return gInstance;
}

@end
