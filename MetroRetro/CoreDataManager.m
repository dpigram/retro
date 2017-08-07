//
//  CoreDataManager.m
//  MetroRetro
//
//  Created by Terell Pigram on 8/5/17.
//  Copyright © 2017 Terell Pigram. All rights reserved.
//

#import "CoreDataManager.h"
#import <CoreData/CoreData.h>
@implementation CoreDataManager

static NSPersistentStoreCoordinator *persistentStoreCoordinator;
static NSManagedObjectContext *privateContext;
static NSManagedObjectContext *mainContext;
static CoreDataManager *sharedManager;

+ (CoreDataManager*) sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[CoreDataManager alloc] init];
    });
    return sharedManager;
}

-(id)init{
    self = [super init];
    
    if(self){
        privateContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [privateContext setPersistentStoreCoordinator:persistentStoreCoordinator];
        
        mainContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [mainContext setParentContext:privateContext];
    }
    return self;
}

+ (void) initializeCoredataStack{
    NSURL *storeURL = [[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] URLByAppendingPathComponent:@"MetroRetro.sqlite"];
    NSError *error  = nil;
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"MetroRetro" withExtension:@"momd"];
    NSManagedObjectModel *managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    if(persistentStoreCoordinator == nil){
        persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
        
        if(![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]){
            NSLog(@"error creating persistentStoreCoordinator: %@", [error localizedDescription]);
        }
    }
}

// helper methods
- (NSManagedObjectContext *)createTempContext{
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [context setParentContext:mainContext];
    return context;
}

- (void)saveTempContext: (NSManagedObjectContext *)context withCompletionHandler: (void (^)(void)) completion {
    [context performBlock:^{
        NSError *saveError;
        [context save:&saveError];
        [mainContext performBlock:^{
           NSError *saveError;
           [mainContext save:&saveError];
           [privateContext performBlock:^{
              NSError *saveError;
              [privateContext save:&saveError];
               [mainContext performBlock:^{
                   completion();
               }];
           }];
        }];
    }];
}

// insert requests
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

// delete requests
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

// get requests
- (BOOL)userExistsByUsername: (NSString *) username {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Usersettings"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"username = %@", username];
    [request setPredicate:predicate];
    
    NSError *error;
    NSUInteger count = [mainContext countForFetchRequest:request error:&error];
    
    if(count > 0){
        return true;
    }
    else{
        return false;
    }
}

- (NSManagedObject *)getLoggedInUsersettingsByUsername: (NSString *) username {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Usersettings"];
    NSPredicate *predicate= [NSPredicate predicateWithFormat:@"username = %@", username];
    [request setPredicate:predicate];
    
    NSError * error;
    NSArray* results = [mainContext executeFetchRequest:request error:&error];
    if(results.count > 0){
        return results[0];
    }
    else{
        return nil;
    }
}

@end
