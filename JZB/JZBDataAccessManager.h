//
//  JZBDataAccessManager.h
//  JZB
//
//  Created by Jin Jin on 11-3-30.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "JZBManagedObject.h"
#import "/usr/include/sqlite3.h"

////define a notification for data changing
//#define NOTIFICATION_JZBDATACHANGED @"NOTIFICATION_JZBDATACHANGED"

@interface JZBDataAccessManager : NSObject {

}


+(NSArray*)getObjectsForModel:(NSString*)modelName key:(NSString*)key value:(NSString*)value;
+(NSArray*)getAllObjectsForModel:(NSString*)modelName;
+(NSArray*)getAllObjectsForModel:(NSString*)modelName context:(NSManagedObjectContext*)context;
+(BOOL)saveManagedObjects:(NSArray*)objList;
+(BOOL)deleteManagedObjects:(NSArray*)objList;
+(void)deleteSingleObject:(JZBManagedObject*)obj;
//fetch result by SQL leaguage
+(NSArray*)fetchResultBySQL:(NSString*)sqlquery;

//let sync modal know that there is something changed, content of changing is included in notification
//+(void)sendChangedNotification:(NSNotification*)notification;
//start an update thread. If there is another updating thread, current thread should be waiting
+(void)dbLock;
//declare that current thread is finished updating
+(void)dbUnlock;

@end

@interface JZBDataAccessManager (private)

//fetch all instances using given model name, with it’s property name and value
+(NSArray*)getInstancesWithModelName:(NSString*)modelName
                           predicate:(NSPredicate*)predicate 
                             context:(NSManagedObjectContext*)context;
+(NSLock*)locker;

@end