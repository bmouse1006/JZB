//
//  JJObjectManager.h
//  JZB
//
//  Created by Jin Jin on 11-3-29.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

#define EXCEPTION_COMMITFAILED @"EXCEPTION_COMMITFAILED"
#define EXCEPTION_KEY_ERROR @"error"

@interface JJObjectManager : NSObject {
    
}

+(void)clearObjects; //clear cached object
+(BOOL)deleteObject:(NSManagedObject*)object; //delete a NSNanagedObject
+(BOOL)insertObject:(NSManagedObject*)object; //insert a NSManagedObject
+(BOOL)commitChangeForContext:(NSManagedObjectContext*)context; //commit a context
+(void)didReceiveMemoryWarning; 
+(NSManagedObjectContext*)context; //generate a context

//fetch objects according to predicate, sorted by descriptoers
+(NSFetchedResultsController*)fetchedResultsControllerFromModel:(NSString*)objectModel 
													  predicate:(NSPredicate*)predicate
												sortDescriptors:(NSArray*)descriptors
                                                        context:(NSManagedObjectContext*)context; 

//get all objects with given name and key and vlaue
+(NSArray*)objectsByModelName:(NSString*)modelName withKey:(NSString*)key andValue:(NSString*)value;
+(NSArray*)objectsByModelName:(NSString*)modelName withKey:(NSString*)key andValue:(NSString*)value context:(NSManagedObjectContext*)context;
+(NSArray*)objectsByModelName:(NSString*)modelName;
+(NSArray*)objectsByModelName:(NSString*)modelName context:(NSManagedObjectContext*)context;
//create a new managed object with model name and given context
+(NSManagedObject*)newManagedObjectWithModelName:(NSString*)modelName context:(NSManagedObjectContext*)context;
//create a new managed object with model name, new context will be given
+(NSManagedObject*)newManagedObjectWithModelName:(NSString*)modelName;

@end

@interface JJObjectManager (private)

+(NSManagedObjectModel*)managedObjectModel; //provide a singleton instance of NSManagedObjectModel
+(NSPersistentStoreCoordinator *)persistentStoreCoordinator; //provide a singleton instance of NSPersistentStoreCoordinator
+(NSString*)applicationDocumentsDirectory; //provide the dynamic documents directory
+(NSMutableDictionary*)cachedObjects; //the dictionary for cached objects

@end