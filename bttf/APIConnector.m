//
//  APIConnector.m
//  BackToTheFarm
//
//  Created by Siddhant Dange on 1/5/15.
//  Copyright (c) 2015 Siddhant Dange. All rights reserved.
//

#import "APIConnector.h"
#import "User.h"


#define API_URL @"https://1f70d9e9.ngrok.com"
//#define API_URL @"http://backtothefarm.herokuapp.com"

@implementation APIConnector

-(void)updateMeat:(NSDictionary*)meatData WithCompletion:(void(^)(NSDictionary*))completion{
    [self makeRequestAtUrl:[self meatUpdateUrl]
                      post:YES
                      data:@{
                             @"perc_data" : meatData[@"perc_data"],
                             @"meat_data" : meatData[@"meat_data"],
                             @"token" : [User sharedInstance].token
                             }
                completion:^(NSDictionary *data, NSError *error) {
                    if(error){
                        NSLog(@"error updating meat");
                    }
                    
                    completion(data);
                }];
}

-(void)readMeatWithCompletion:(void(^)(NSDictionary*))completion{
    [self makeRequestAtUrl:[self meatReadUrl]
                      post:YES
                      data:@{
                             @"token" : [User sharedInstance].token
                             }
                completion:^(NSDictionary *data, NSError *error) {
                    if(error){
                        NSLog(@"error reading meat");
                    }
                    
                    completion(data);
                }];
}

-(void)createUserWithUsername:(NSString*)username password:(NSString*)password email:(NSString*)email completion:(void(^)(NSDictionary*, NSError*))completion{
    
        [self makeRequestAtUrl:[self userCreateUrl]
                          post:YES
                          data:@{
                                 @"username" : username,
                                 @"password" : password,
                                 @"email_address" : email
                                 }
                    completion:^(NSDictionary *data, NSError *error) {
                        
                        NSLog(@"Error: %@", [error debugDescription]);
                        NSLog(@"Error: %@", [error localizedDescription]);                        
                        
                        if(error){
                            NSLog(@"error creating user: %@", error);
                        }
                        
                        completion(data,error);
                    }];
}

-(void)loginUserWithUsername:(NSString*)username password:(NSString*)password completion:(void(^)(NSDictionary*, NSError*))completion{
    [self makeRequestAtUrl:[self userLoginUrl]
                      post:YES
                      data:@{
                        @"username" : username,
                        @"password" : password
                      }
                completion:^(NSDictionary *data, NSError *error) {
        if(error){
            NSLog(@"error logging in user: %@", error);
        }
        
        completion(data,error);
    }];
}

-(void)makeRequestAtUrl:(NSString*)urlStr post:(BOOL)post data:(NSDictionary*)data completion:(void(^)(NSDictionary*, NSError*))completion{
    
    NSURL *url = [[NSURL alloc] initWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    if(post){
        request.HTTPMethod = @"POST";
        
        if(data){
            NSError *error;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data
                                                               options:NSJSONWritingPrettyPrinted
                                                                 error:&error];
            request.HTTPBody = jsonData;
        }
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    } else{
        request.HTTPMethod = @"GET";
    }
    

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (!data) {
            completion(nil, connectionError);
            return;
        }
        
        //JSON array or object
        NSError *jsonError = nil;
        NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
        
        if(data && response && completion){
            completion(dataDict, jsonError);
        }
    }];


}

#pragma -mark File Access

-(void)writeDictionaryToFile:(NSDictionary*)data withName:(NSString*)name{
    NSString *documentsDirectory = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *fileName = [NSString stringWithFormat:@"%@/%@.txt", documentsDirectory, name];
    [data writeToFile:fileName
           atomically:NO];
}

-(NSDictionary*)readDictionaryFromFile:(NSString*)name{
    NSString *documentsDirectory = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *fileName = [NSString stringWithFormat:@"%@/%@.txt", documentsDirectory, name];
    return [[NSDictionary alloc] initWithContentsOfFile:fileName];
}

-(void)writeStringToFile:(NSString*)data withName:(NSString*)name{
    NSString *documentsDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *path = [NSString stringWithFormat:@"%@/%@.txt", documentsDirectory, name];
    [data writeToFile:path atomically:YES encoding:NSStringEncodingConversionAllowLossy error:Nil];
}

-(NSString*)readStringToFile:(NSString*)name{
    NSString *documentsDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *path = [NSString stringWithFormat:@"%@/%@.txt", documentsDirectory, name];
    return [NSString stringWithContentsOfFile:path encoding:NSStringEncodingConversionAllowLossy error:Nil];
}

-(NSString*)userCreateUrl{
    return [NSString stringWithFormat:@"%@/user/create", API_URL];
}

-(NSString*)userLoginUrl{
    return [NSString stringWithFormat:@"%@/user/login", API_URL];
}

-(NSString*)meatReadUrl{
    return [NSString stringWithFormat:@"%@/meat/read", API_URL];
}

-(NSString*)meatUpdateUrl{
    return [NSString stringWithFormat:@"%@/meat/update", API_URL];
}

@end
