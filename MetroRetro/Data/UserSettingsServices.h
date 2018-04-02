//
//  UserSettingsServices.h
//  MetroRetro
//
//  Created by Terell Pigram on 4/1/18.
//  Copyright © 2018 Terell Pigram. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreDataManager.h"
@interface UserSettingsServices : CoreDataManager
+ (UserSettingsServices*) sharedService;


- (NSManagedObject *)getLoggedInUsersettings;
- (void)insertUserserttingsWithDictionary: (NSDictionary *)userData withCompletionHandler: (void (^)(void))completion;
- (void)deleteUserSettingsWithCompletionHandler: (void(^)(void)) completion;
- (BOOL)userExistsByUsername: (NSString *) username;
@end
