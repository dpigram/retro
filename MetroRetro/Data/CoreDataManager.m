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
        mainContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [mainContext setPersistentStoreCoordinator:persistentStoreCoordinator];
        privateContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [privateContext setParentContext:mainContext];
        
    }
    return self;
}

- (NSManagedObjectContext *)getMainContext{
    return mainContext;
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

@end
