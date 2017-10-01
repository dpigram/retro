//
//  LoginServices.h
//  MetroRetro
//
//  Created by Terell Pigram on 8/5/17.
//  Copyright © 2017 Terell Pigram. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MRTeam;

@interface LoginServices : NSObject
+ (id)shareInstance;

- (void)authenticateWithUsername: (NSString *) username
                     andPassword: (NSString *)password
           withCompletionHandler: (void (^)(NSDictionary *data, NSError *error)) completion;

- (void)requestAllTeamsWithCompletionHandler:(void (^)(NSArray *data, NSError *error)) completion;

- (void)replaceUserSettingsWithUserData: (NSDictionary *)userdata withCompletionHandler: (void (^)(void)) completion;

-(void)requestTeamForUser:(NSInteger) userId completionHandler:(void (^)(NSArray<MRTeam*> *teams, NSError *error))completion;
@end
