//
//  UserSettingsServices.m
//  MetroRetro
//
//  Created by Terell Pigram on 4/1/18.
//  Copyright © 2018 Terell Pigram. All rights reserved.
//

#import "UserSettingsServices.h"

@implementation UserSettingsServices
static UserSettingsServices *sharedService;

#pragma mark: Singleton
+ (UserSettingsServices*) sharedService {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedService = [[UserSettingsServices alloc] init];
    });
    return sharedService;
}

#pragma mark: Insert Methods
- (void)insertUserserttingsWithDictionary: (NSDictionary *)userData withCompletionHandler: (void (^)(void))completion{
    NSManagedObjectContext *context = [self createTempContext];
    
    [context performBlock:^{
        NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:@"Usersettings" inManagedObjectContext:context];
        
        [object setValue:[userData valueForKey:@"email"] forKey:@"email"];
        [object setValue:[NSString stringWithFormat:@"%@", [userData valueForKey:@"id"]] forKey:@"id"];
        [object setValue:[userData valueForKey:@"username"] forKey:@"username"];
        
        [self saveTempContext:context withCompletionHandler:^{
            completion();
        }];
    }];
}

#pragma mark: Delete Usersettings
- (void)deleteUserSettingsWithCompletionHandler: (void(^)(void)) completion{
    NSManagedObjectContext *context = [self createTempContext];
    [context performBlock:^{
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Usersettings"];
        NSBatchDeleteRequest *delete = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
        
        NSError *deleteError;
        [context executeRequest:delete error:&deleteError];
        [self saveTempContext:context withCompletionHandler:^{
            completion();
        }];
    }];
}

#pragma mark: Get Methods
- (BOOL)userExistsByUsername: (NSString *) username {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Usersettings"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"username = %@", username];
    [request setPredicate:predicate];
    
    NSError *error;
    NSUInteger count = [[self getMainContext] countForFetchRequest:request error:&error];
    
    if(count > 0){
        return true;
    }
    else{
        return false;
    }
}

- (NSManagedObject *)getLoggedInUsersettings{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Usersettings"];
    
    NSError * error;
    NSArray* results = [[self getMainContext] executeFetchRequest:request error:&error];
    if(results.count > 0){
        return results[0];
    }
    else{
        return nil;
    }
}
@end
