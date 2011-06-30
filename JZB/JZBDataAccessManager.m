//
//  JZBDataAccessManager.m
//  JZB
//
//  Created by Jin Jin on 11-3-30.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "JZBDataAccessManager.h"
#import "JJObjectManager.h"
#import "JZBSynchronizer.h"

@implementation JZBDataAccessManager

static NSLock* dbLocker = nil;

+(void)deleteAccount:(JZBAccounts*)account{
    [self deleteManagedObjects:[NSArray arrayWithObject:account]];
    //remove all bills belone to this account
    //how about to-account?
    //update all to account id to nil for bills that transfer into this account
}
     
+(void)deleteCatalog:(JZBCatalogs*)catalog{
    [self deleteManagedObjects:[NSArray arrayWithObject:catalog]];
    //update all catalog id in bills to nil
}

+(void)deleteBill:(JZBBills*)bill{
    [self deleteManagedObjects:[NSArray arrayWithObject:bill]];
}

+(NSArray*)getObjectsForModel:(NSString*)modelName key:(NSString*)key value:(NSString*)value{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"%K like %@", key, value];
    return [self getInstancesWithModelName:modelName predicate:predicate context:nil];
}

+(NSArray*)getAllObjectsForModel:(NSString*)modelName{
    return [self getAllObjectsForModel:modelName context:nil];
}

+(NSArray*)getAllObjectsForModel:(NSString*)modelName context:(NSManagedObjectContext*)context{
    return [self getInstancesWithModelName:modelName predicate:nil context:context];
}

+(BOOL)saveManagedObjects:(NSArray*)objList{
    BOOL result = NO;
    [self dbLock];
    @try {
        for (JZBManagedObject* obj in objList){
            //commitchange to local database
            [JJObjectManager commitChangeForContext:[obj managedObjectContext]];
            //add to change queue in synchronizer
            [[JZBSynchronizer defaultSynchronizer] addLocalChange:[JZBDataChangeUnit dataChangeUnitWithJZBManagedObject:obj]];
        }
    }
    @catch (NSException *exception) {
        DebugLog(@"error happened while saving changes. Reason is %@", exception.reason);
    }@finally {
        [self dbUnlock];
    }
    return result;
}

+(BOOL)deleteManagedObjects:(NSArray*)objList{
    BOOL result = NO;

    for (JZBManagedObject* obj in objList){
        //commit change to local database
        result = [self deleteSingleObject:obj];
        //add this action to local change queue of synchronizer
        if (result == YES){
            [[JZBSynchronizer defaultSynchronizer] addLocalDeleteForTable:[obj tableName]                            
                                                                 keyValue:obj.keyValue];
        }else{
            break;
        }
    }

    return result;
}

+(BOOL)deleteSingleObject:(JZBManagedObject*)obj{
    BOOL result = NO;
    [self dbLock];
    @try {    
        //move the record to deleted table
        //step 1: create a new record in the cooresponding deleted table
        //step 2: remove original record
        JZBManagedObject* deletedObj = [obj newObjectForDeletedTable];
        [JJObjectManager deleteObject:obj];
        [JJObjectManager commitChangeForContext:[obj managedObjectContext]];
        [JJObjectManager commitChangeForContext:[deletedObj managedObjectContext]];
    }@catch (NSException* e) {
        result = NO;
        DebugLog(@"error happened while deleting objects. Reason is %@", e.reason);
    }@finally {
        result = YES;
        [self dbUnlock];
    }
    
    return result;
}

//fetch result by SQL leaguage
+(NSArray*)fetchResultBySQL:(NSString*)sqlquery{
    DebugLog(@"SQL is %@", sqlquery);
    sqlite3* _database;
    //lock DB
    [self dbLock];
    NSMutableArray* result = [NSMutableArray arrayWithCapacity:0];
    //open DB
    NSArray *documentsPaths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
    NSString *databaseFilePath=[[documentsPaths objectAtIndex:0] stringByAppendingPathComponent:[DB_FILENAME stringByAppendingString:DB_FILENAME_EXTENSION]];
    if (sqlite3_open([databaseFilePath UTF8String], &_database)==SQLITE_OK) { 
        DebugLog(@"open sqlite db ok."); 
    }
    //do query
    const char* sql = [sqlquery cStringUsingEncoding:NSUTF8StringEncoding];
    sqlite3_stmt* statement = nil;
    if (sqlite3_prepare_v2(_database, sql, -1, &statement, nil)==SQLITE_OK) { 
        DebugLog(@"select ok."); 
    }
    
    //collect result
    while (sqlite3_step(statement)==SQLITE_ROW) {
        NSMutableDictionary* row = [NSMutableDictionary dictionaryWithCapacity:0];
        for (int i = 0; i<sqlite3_column_count(statement); i++){
            NSString* name = [NSString stringWithCString:sqlite3_column_name(statement, i) 
                                                encoding:NSUTF8StringEncoding];
            int type = sqlite3_column_type(statement, i);
            id obj = nil;
            switch (type) {
                case SQLITE_INTEGER:
                    obj = [NSNumber numberWithInt:sqlite3_column_int(statement, i)];
                    break;
                case SQLITE_FLOAT:
                    obj = [NSNumber numberWithDouble:sqlite3_column_double(statement, i)];
                    break;
                case SQLITE_TEXT:
                    obj = [NSString stringWithCString:sqlite3_column_text(statement, i)
                                             encoding:NSUTF8StringEncoding];
                    break;
                case SQLITE_BLOB:
                    break;
                case SQLITE_NULL:
                    break;
                default:
                    break;
            }
            
            if (obj){
                [row setValue:obj forKey:name];
            }
        }
        [result addObject:row];
    }
    
    //close DB
    
    sqlite3_close(_database);
    //unlock DB
    [self dbUnlock];
    return result;
}

//start an update thread. If there is another updating thread, current thread should be waiting
+(void)dbLock{
    [[self locker] lock];
}

//declare that current thread is finished updating
+(void)dbUnlock{
    [[self locker] unlock];
}

@end

@implementation JZBDataAccessManager (private)

//fetch all instances using given model name, with it’s property name and value
+(NSArray*)getInstancesWithModelName:(NSString*)modelName 
                           predicate:(NSPredicate*)predicate context:(NSManagedObjectContext *)context{
    NSFetchedResultsController* fetchedResults = [JJObjectManager fetchedResultsControllerFromModel:modelName predicate:predicate sortDescriptors:[NSArray arrayWithObjects:nil] context:context];
    NSError* error = nil;
    NSArray* result = nil;
    [self dbLock];
    [fetchedResults performFetch:&error];
    [self dbUnlock];
    if (!error){
        result = [fetchedResults fetchedObjects];
    }
    return result;
}

+(NSLock*)locker{
    if (!dbLocker){
        dbLocker = [[NSLock alloc] init];
    }
    
    return dbLocker;
}

@end
