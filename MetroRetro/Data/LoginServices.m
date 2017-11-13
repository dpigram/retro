    //
//  LoginServices.m
//  MetroRetro
//
//  Created by Terell Pigram on 8/5/17.
//  Copyright © 2017 Terell Pigram. All rights reserved.
//

#import "LoginServices.h"
#import "CoreDataManager.h"
#import "Constants.h"
#import "MetroRetro-Swift.h"

@interface LoginServices()

@end

@implementation LoginServices
//http://localhost:8000/user/teams/
+ (id)shareInstance {
    static dispatch_once_t onceToken = 0;
    static LoginServices *shared = nil;
    
    dispatch_once(&onceToken, ^{
        shared = [[LoginServices alloc] init];
    });
    
    return shared;
}

- (void)authenticateWithUsername: (NSString *) username
                     andPassword: (NSString *)password
           withCompletionHandler: (void (^)(NSDictionary *data, NSError *error)) completion {
    NSLog(@"user does not exist");
    // if user does not exist, do web service call
    NSString *urlString = [NSString stringWithFormat:@"%@/user/auth", kBaseURL];
    
    NSMutableURLRequest *request = [self urlRequestWithUrlString:urlString method:@"POST"];
    
    NSString *postParams = [NSString stringWithFormat:@"username=%@&password=%@", username, password];
    NSData *postData = [postParams dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:postData];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"RESPONSE: %@",response);
        NSLog(@"DATA: %@",data);
        
        if (!error) {
            // Success
            if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                NSError *jsonError;
                NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
                
                if (jsonError) {
                    // Error Parsing JSON
                } else {
                    // Success Parsing JSON
                    // Log NSDictionary response:
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (!jsonResponse){
                            completion([NSDictionary new], error);
                        } else {
                            completion(jsonResponse, nil);
                        }
                    });
                }
            }  else {
                //Web server is returning an error
            }
        } else {
            // Fail
            NSLog(@"error : %@", error.description);
        }
    }] resume];
}

-(void)requestAllTeamsWithCompletionHandler:(void (^)(NSArray *dictionary, NSError *error))completion {
    NSString *urlString = [NSString stringWithFormat:@"%@/teams", kBaseURL];
    NSMutableURLRequest *request = [self urlRequestWithUrlString:urlString method:@"GET"];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    [[session dataTaskWithRequest:request
               completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                   if(!error) {
                       NSError *jsonError = nil;
                       id teams = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
                       if(!error){
                           if (!teams) {
                               completion([NSArray new], nil);
                           } else {
                               if ([teams isKindOfClass:[NSArray class]]) {
                                   NSArray *arrTeams = [NSArray arrayWithArray:(NSArray *)teams];
                                   
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       completion(arrTeams, nil);
                                   });
                                   
                               } else {
                                   NSLog(@"Error: expecting an array");
                               }
                           }
                       } else {
                           //handle error
                       }
                   } else {
                       //handle error
                   }
               }] resume];
}

-(void)requestTeamForUser:(NSInteger) userId completionHandler:(void (^)(NSArray<MRTeam*> *teams, NSError *error))completion {
    NSString *urlString = [NSString stringWithFormat:@"%@/user/teams/", kBaseURL];
    NSMutableURLRequest *request = [self urlRequestWithUrlString:urlString method:@"POST"];
    
    NSString *postParams = [NSString stringWithFormat:@"userId=%ld", userId];
    NSData *postData = [postParams dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:postData];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    [[session dataTaskWithRequest:request
                completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                    if(!error) {
                        NSError *jsonError = nil;
                        id teams = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
                        if(!error){
                            if (!teams) {
                                completion([NSArray new], nil);
                            } else {
                                if ([teams isKindOfClass:[NSArray class]]) {
                                    NSArray *serverTeams = [NSArray arrayWithArray:(NSArray *)teams];
                                    
                                    NSMutableArray *displayTeams = [NSMutableArray new];
                                    for (NSDictionary *dict in serverTeams) {
                                        MRTeam *team = [[MRTeam alloc] initWithTeamId:[dict[@"id"] integerValue]
                                                                                 name:dict[@"name"]
                                                                              ownerId:[dict[@"owner"] integerValue]
                                                                                 desc:dict[@"description"]];
                                        [displayTeams addObject:team];
                                    }
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        completion(displayTeams, nil);
                                    });
                                } else {
                                    NSLog(@"Error: expecting an array");
                                }
                            }
                        } else {
                            //handle error
                        }
                    } else {
                        //handle error
                    }
                }] resume];
}

-(void)requestRetrosForTeam:(NSInteger) teamId completionHandler:(void (^)(NSArray<MRRetro*> *teams, NSError *error))completion {
    NSString *urlString = [NSString stringWithFormat:@"%@/retros/", kBaseURL];
    NSMutableURLRequest *request = [self urlRequestWithUrlString:urlString method:@"POST"];
    
    NSString *postParams = [NSString stringWithFormat:@"teamId=%ld", teamId];
    NSData *postData = [postParams dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:postData];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    [[session dataTaskWithRequest:request
                completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                    if(!error) {
                        NSError *jsonError = nil;
                        id retros = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
                        if(!error){
                            if (!retros) {
                                completion([NSArray new], nil);
                            } else {
                                if ([retros isKindOfClass:[NSArray class]]) {
                                    NSArray *serverRetros = [NSArray arrayWithArray:(NSArray *)retros];
                                    
                                    NSMutableArray *displayRetros = [NSMutableArray new];
                                    NSLog(@"%@", displayRetros);
                                    for (NSDictionary *dict in serverRetros) {
                                        
                                    }
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        completion(displayRetros, nil);
                                    });
                                } else {
                                    NSLog(@"Error: expecting an array");
                                }
                            }
                        } else {
                            //handle error
                        }
                    } else {
                        //handle error
                    }
                }] resume];
}

- (void)replaceUserSettingsWithUserData: (NSDictionary *)userdata withCompletionHandler: (void (^)(void)) completion {
    // remove old useraettings
    [[CoreDataManager sharedManager] deleteUserSettingsWithCompletionHandler:^{
        [[CoreDataManager sharedManager] insertUserserttingsWithDictionary:userdata withCompletionHandler:^{
            completion();
        }];
    }];
}

- (NSMutableURLRequest *)urlRequestWithUrlString:(NSString *) url method:(NSString *)method {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    NSString *authStr = @"tpigram:admin123";
    NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64EncodedStringWithOptions:0]];
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    [request setHTTPMethod:method];
    
    return request;
}
@end
