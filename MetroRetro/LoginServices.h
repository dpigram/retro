//
//  LoginServices.h
//  MetroRetro
//
//  Created by Terell Pigram on 8/5/17.
//  Copyright © 2017 Terell Pigram. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginServices : NSObject
- (void)AuthenticateWithUsername: (NSString *) username andPassword: (NSString *)password withCompletionHandler: (void (^)(NSDictionary *data)) completion;

- (void)replaceUserSettingsWithUserData: (NSDictionary *)userdata withCompletionHandler: (void (^)(void)) completion;
@end
