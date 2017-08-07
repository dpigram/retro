//
//  LoginServices.m
//  MetroRetro
//
//  Created by Terell Pigram on 8/5/17.
//  Copyright © 2017 Terell Pigram. All rights reserved.
//

#import "LoginServices.h"
#import "CoreDataManager.h"
#import "constants.h"

@interface LoginServices()

@end

@implementation LoginServices

- (void)AuthenticateWithUsername: (NSString *) username andPassword: (NSString *)password withCompletionHandler: (void (^)(NSDictionary *data)) completion{

    NSLog(@"user does not exist");
    // if user does not exist, do web service call
    NSString *urlString = [NSString stringWithFormat:@"%@/user/auth", kBaseURL];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    NSString *authStr = @"tpigram:admin123";
    NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64EncodedStringWithOptions:0]];
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    [request setHTTPMethod:@"POST"];
    
    NSString *postParams = [NSString stringWithFormat:@"username=%@&password=%@", username, password];
    NSData *postData = [postParams dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:postData];
    
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
                    NSLog(@"%@",jsonResponse);
                    completion(jsonResponse);
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

- (void)replaceUserSettingsWithUserData: (NSDictionary *)userdata withCompletionHandler: (void (^)(void)) completion {
    // remove old useraettings
    [[CoreDataManager sharedManager] deleteUserSettingsWithCompletionHandler:^{
        [[CoreDataManager sharedManager] insertUserserttingsWithDictionary:userdata withCompletionHandler:^{
            completion();
        }];
    }];
}
@end
