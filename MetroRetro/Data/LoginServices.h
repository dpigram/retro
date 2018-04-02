//
//  LoginServices.h
//  MetroRetro
//
//  Created by Terell Pigram on 8/5/17.
//  Copyright © 2017 Terell Pigram. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserSettingsServices.h"
@class MRTeam;
@class MRRetro;

@interface LoginServices : NSObject
+ (id)shareInstance;

- (void)authenticateWithUsername: (NSString *) username
                     andPassword: (NSString *)password
           withCompletionHandler: (void (^)(NSDictionary *data, NSError *error)) completion;

- (void)requestAllTeamsWithCompletionHandler:(void (^)(NSArray *data, NSError *error)) completion;

- (void)replaceUserSettingsWithUserData: (NSDictionary *)userdata withCompletionHandler: (void (^)(void)) completion;

-(void)requestTeamForUser:(NSInteger) userId completionHandler:(void (^)(NSArray<MRTeam*> *teams, NSError *error))completion;

-(void)requestRetrosForTeam:(NSInteger) teamId completionHandler:(void (^)(NSArray<MRRetro*> *teams, NSError *error))completion;
@end
