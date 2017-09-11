//
//  CoreDataManager.h
//  MetroRetro
//
//  Created by Terell Pigram on 8/5/17.
//  Copyright © 2017 Terell Pigram. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataManager : NSObject
+ (CoreDataManager*) sharedManager;
+ (void) initializeCoredataStack;

// Usersetting get methods;
- (BOOL)userExistsByUsername: (NSString *) username;
- (NSManagedObject *)getLoggedInUsersettingsByUsername: (NSString *) username;

// Usersettings delete methods
- (void)deleteUserSettingsWithCompletionHandler: (void(^)(void)) completion;

// Usersetting insert methods
- (void)insertUserserttingsWithDictionary: (NSDictionary *)userData withCompletionHandler: (void (^)(void))completion;
@end
