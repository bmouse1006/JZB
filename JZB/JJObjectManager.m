//
//  JJObjectManager.m
//  JZB
//
//  Created by Jin Jin on 11-3-29.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "JJObjectManager.h"

@implementation JJObjectManager

static NSPersistentStoreCoordinator* persistentStoreCoordinator = nil;
static NSManagedObjectModel* mom = nil;
static NSMutableDictionary* cachedObjects = nil;

//clear cached objects;
+(void)clearObjects{
    //need to commit change before clear anything
    //TBD
    [cachedObjects removeAllObjects];
}

//delete a NSNanagedObject
+(BOOL)deleteObject:(NSManagedObject*)object{
    NSManagedObjectContext* context = [object managedObjectContext];
    [context deleteObject:object];
    return YES;
}

//insert a NSManagedObject
+(BOOL)insertObject:(NSManagedObject*)object{
    NSManagedObjectContext* context = [object managedObjectContext];
    [context insertObject:object];
    return YES;
};

//commit a context
+(BOOL)commitChangeForContext:(NSManagedObjectContext*)context{
    NSError* error = nil;
    [context save:&error];
    BOOL result = NO;
    if (error){
        result = NO;
        DebugLog(@"error is %@", [error localizedDescription]);
        DebugLog(@"throws exception %@", EXCEPTION_COMMITFAILED);
        //raise an exception
        NSException* exp = [NSException exceptionWithName:EXCEPTION_COMMITFAILED 
                                                   reason:[error localizedDescription]
                                                 userInfo:nil];
        [exp raise];
    }else{
        result = YES;
    }
    return result;
}

+(void)didReceiveMemoryWarning{
    [self clearObjects];
    return;
}

//generate a context
+(NSManagedObjectContext*)context{
    NSManagedObjectContext* context = [[NSManagedObjectContext alloc] init];
    [context setPersistentStoreCoordinator:[self persistentStoreCoordinator]];
    return [context autorelease];
}

//fetch objects according to predicate, sorted by descriptoers
+(NSFetchedResultsController*)fetchedResultsControllerFromModel:(NSString*)objectModel 
													  predicate:(NSPredicate*)predicate
												sortDescriptors:(NSArray*)descriptors
                                                        context:(NSManagedObjectContext*)mContext{
    NSManagedObjectContext* context = nil;
    if (!mContext){
        context = [self context];
    }else{
        context = mContext;
    }
	
	NSFetchRequest* request = [[NSFetchRequest alloc] init];
	NSEntityDescription* entity = [NSEntityDescription entityForName:objectModel 
											  inManagedObjectContext:context];
	[request setEntity:entity];
	[request setPredicate:predicate];
    //descriptor should not be nil
    if (!descriptors){
        descriptors = [NSArray array];
    }
	[request setSortDescriptors:descriptors];
	
	NSFetchedResultsController* controller = [[NSFetchedResultsController alloc] initWithFetchRequest:request
																				 managedObjectContext:context
                                                                                   sectionNameKeyPath:nil 
                                                                                            cacheName:nil];
	
	[request release];
	
	return [controller autorelease];
}

+(NSArray*)objectsByModelName:(NSString*)modelName withKey:(NSString*)key andValue:(NSString*)value{
    return [self objectsByModelName:modelName 
                            withKey:key
                           andValue:value
                            context:nil];
}

+(NSArray*)objectsByModelName:(NSString*)modelName withKey:(NSString*)key andValue:(NSString*)value context:(NSManagedObjectContext*)context{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"%K like %@", key, value];
    DebugLog(@"predicate is %@", [predicate description]);
    NSFetchedResultsController* fetchController = [self fetchedResultsControllerFromModel:modelName 
                                                                                predicate:predicate 
                                                                          sortDescriptors:nil 
                                                                                  context:context];
    NSError* error = nil;
    [fetchController performFetch:&error];
    return fetchController.fetchedObjects;
}

+(NSManagedObject*)newManagedObjectWithModelName:(NSString*)modelName{
	return [self newManagedObjectWithModelName:modelName context:[self context]];
}

+(NSManagedObject*)newManagedObjectWithModelName:(NSString*)modelName context:(NSManagedObjectContext*)context{
    NSManagedObject* obj = (NSManagedObject*)[NSEntityDescription insertNewObjectForEntityForName:modelName 
                                                                           inManagedObjectContext:context];
    return obj;
}

+(NSArray*)objectsByModelName:(NSString*)modelName{
    return [self objectsByModelName:modelName context:nil];
}

+(NSArray*)objectsByModelName:(NSString*)modelName context:(NSManagedObjectContext*)context{
    NSFetchedResultsController* fetchController = [self fetchedResultsControllerFromModel:modelName 
                                                                                predicate:nil
                                                                          sortDescriptors:nil
                                                                                  context:context];
    NSError* error = nil;
    [fetchController performFetch:&error];
    return fetchController.fetchedObjects;
}

@end

@implementation JJObjectManager (private)

+(NSManagedObjectModel*)managedObjectModel{
    if (mom){
        return mom;
    }
    
    mom = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];
    
    return mom;
}

+(NSPersistentStoreCoordinator*)persistentStoreCoordinator{
    if (persistentStoreCoordinator){
        return persistentStoreCoordinator;
    }
    
    NSString* storePath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:[DB_FILENAME stringByAppendingString:DB_FILENAME_EXTENSION]];
    
    NSURL* url = [NSURL fileURLWithPath:storePath];
    
    NSDictionary* options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    NSError* error = nil;
    
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType 
                                                  configuration:nil
                                                            URL:url
                                                        options:options
                                                          error:&error]){
        DebugLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    
    
    return persistentStoreCoordinator;
}

//return directory for this application
+(NSString*)applicationDocumentsDirectory{
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* basePath = ([paths count] > 0)?[paths objectAtIndex:0]:nil;
    
    return basePath;
    
}

+(NSMutableDictionary*)cachedObjects{
    if (cachedObjects){
        return cachedObjects;
    }
    
    cachedObjects = [[NSMutableDictionary alloc] initWithCapacity:0];
    return cachedObjects;
}

@end
