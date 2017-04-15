//
//  DataStore.m
//  Reservation
//
//  Created by Tarun Gupta on 2/19/17.
//  Copyright © 2017 Tarun Gupta. All rights reserved.
//

#import "DataStore.h"

@implementation DataStore

+ (id)sharedManager {
    static DataStore *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (NSManagedObjectContext*)managedObjectContext {
    static NSManagedObjectContext *context = nil;
    
    if(context){
        return context;
    }
    
    NSPersistentStoreCoordinator *coordinator = nil;
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Reservation" withExtension:@"momd"];
    NSManagedObjectModel *objectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    if (!coordinator) {
        coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:objectModel];
    }
    
    if(!coordinator){
        return nil;
    }
    
    NSURL *storeURL = [[self documentsDirectoryPath] URLByAppendingPathComponent:@"Reservation.sqlite"];

    NSError *error;
    
    if (![coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:NULL error:&error])
    {
        NSLog(@"Database error: %@", error);
        // if you make changes to your model and a database already exists in the app
        // you'll get a NSInternalInconsistencyException exception. When the model is updated
        // the databasefile must be removed. Remove the database here because it's easy.
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtURL:storeURL error:nil];
        
        //try to add the persistant store one more time. If it still fails then abort
        if (![coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:NULL error:&error])
            return nil;
    }
    
    context = [[NSManagedObjectContext alloc] init];
    [context setPersistentStoreCoordinator:coordinator];
    [context setUndoManager:nil];
    
    return context;
    
}

- (NSURL *)documentsDirectoryPath
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
