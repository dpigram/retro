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
- (NSManagedObjectContext *)createTempContext;
- (void)saveTempContext: (NSManagedObjectContext *)context withCompletionHandler: (void (^)(void)) completion ;
- (NSManagedObjectContext *)getMainContext;
@end
