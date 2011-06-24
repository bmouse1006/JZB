//
//  JZBDataAccessManager.m
//  JZB
//
//  Created by Jin Jin on 11-3-30.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "JZBDataAccessManager.h"
#import "JJObjectManager.h"
#import "JZBBills.h"
#import "JZBAccounts.h"
#import "JZBCatalogs.h"
#import "JZBBorrowers.h"
#import "JZBBudgets.h"
#import "JZBBudgetItems.h"
#import "JZBSynchronizer.h"

@implementation JZBDataAccessManager

//flag for updating
static NSLock* updating = nil;

static NSMutableArray* deletedObjects = nil;
static NSMutableArray* addedObjects = nil;
static NSMutableArray* modifiedObjects = nil;

//multi thread mutex should be considered for all data change message
+(NSArray*)getAllBills{
    return [self getInstancesWithModelName:BILLMODELNAME predicate:nil];
}

+(NSArray*)getBillsByAccount:(NSString*)accountID{

    return [JJObjectManager objectsByModelName:BILLMODELNAME withKey:@"account_id" andValue:accountID];
}

+(NSArray*)getBillsByCatalog:(NSString*)catalogID{

    return [JJObjectManager objectsByModelName:BILLMODELNAME withKey:@"catalog_id" andValue:catalogID];
}

+(NSArray*)getBillsByPredicate:(NSPredicate*)predicate{

    return [self getInstancesWithModelName:BILLMODELNAME predicate:predicate];
    
}

+(NSArray*)getBillsBetweenStartDate:(NSDate*)startDate andEndDate:(NSDate*)endDate byAccountID:(NSString*)accountID{
    //if account ID is null, return all items fits the caretaria
//    NSPredicate* predicate = nil;
//    if ([accountID length] > 0){
//        NSPredicate* predicate1 = [NSPredicate predicateWithFormat:@"date BETWEEN %@", [NSArray arrayWithObject:startDate, endDate, nil]];
//        NSPredicate* predicate2 = [NSPredicate predicateWithFormat:@"account_id like %@", accountID];
//    }else{
//        
//    }
    
}

+(BOOL)saveBills:(NSArray*)bills{
    
    for (JZBBills* bill in bills){
        [JJObjectManager commitChangeForContext:[bill managedObjectContext]];
    }
    
    return YES;
}

+(BOOL)deleteBills:(NSArray*)bills{
    for (JZBBills* bill in bills){
        [JJObjectManager deleteObject:bill];
    }
    return YES;    
}

+(NSArray*)getAllCatalogs{
    
    return [self getInstancesWithModelName:CATALOGSMODELNAME predicate:nil];
}
+(BOOL)saveCatalogs:(NSArray*)catalogs{
    
    for (JZBCatalogs* catalog in catalogs){
        [JJObjectManager commitChangeForContext:[catalog managedObjectContext]];
    }
    
    return YES;
}

+(BOOL)deleteCatalogs:(NSArray*)catalogs{
    for (JZBCatalogs* catalog in catalogs){
        [JJObjectManager deleteObject:catalog];
    }
    return YES;
}

+(NSArray*)getAllAccounts{
    return [self getInstancesWithModelName:ACCOUNTMODELNAME predicate:nil];
}

+(BOOL)saveAccounts:(NSArray*)accounts{
    for (JZBAccounts* account in accounts){
        [JJObjectManager commitChangeForContext:[account managedObjectContext]];
    }
    return YES;
}

+(BOOL)deleteAccounts:(NSArray*)accounts{
    for (JZBAccounts* account in accounts){
        [JJObjectManager deleteObject:account];
    }
    return YES;
}

+(NSArray*)getAllBorrowers{
    return [self getInstancesWithModelName:BORROWERSMODELNAME predicate:nil];
}

+(BOOL)saveBorrowers:(NSArray*)borrowers{
    for (JZBBorrowers* borrower in borrowers){
        [JJObjectManager commitChangeForContext:[borrower managedObjectContext]];
    }
    return YES;    
}

+(BOOL)deleteBorrowers:(NSArray*)borrowers{
    for (JZBBorrowers* borrower in borrowers){
        [JJObjectManager deleteObject:borrower];
    }
    return YES;
}

+(NSArray*)getAllBudgets{
    NSArray* fetched = [self getInstancesWithModelName:BUDGETMODELNAME predicate:nil];
    
    return fetched;
}

+(BOOL)saveBudgets:(NSArray*)budgets{
    for (JZBBudgets* budget in budgets){
        [JJObjectManager commitChangeForContext:[budget managedObjectContext]];
    }
    return YES;
}

+(BOOL)deleteBudgets:(NSArray*)budgets{
    for (JZBBudgets* budget in budgets){
        [JJObjectManager deleteObject:budget];
    }
    return YES;
}

+(NSArray*)getBudgetItemsByBudgetID:(NSString*)budgetID{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"%K like %@", @"budget_id", budgetID];
    return [self getInstancesWithModelName:BUDGETITEMMODELNAME predicate:predicate];
}

+(BOOL)saveBudgetItems:(NSArray*)budgetItems{
    for (JZBBudgetItems* item in budgetItems){
        [JJObjectManager commitChangeForContext:[item managedObjectContext]];
    }
    
    return YES;
}

+(BOOL)deleteBudgetItems:(NSArray*)budgetItems{
    for (JZBBudgetItems* item in budgetItems){
        [JJObjectManager deleteObject:item];
    }
    
    return YES;
}

//fetch result by SQL leaguage
+(NSArray*)fetchResultBySQL:(NSString*)sqlquery{
    DebugLog(@"SQL is %@", sqlquery);
    sqlite3* _database;
    //lock DB
    [self startUpdating];
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
    
//    [SQLITE_INTEGER],
//    ** [SQLITE_FLOAT], [SQLITE_TEXT], [SQLITE_BLOB], or [SQLITE_NULL].

    //close DB
    
    sqlite3_close(_database);
    //unlock DB
    [self endUpdating];
    return result;
}

//let sync modal know that there is something changed, content of changing is included
//+(void)sendChangedNotification:(NSNotification*)notification{
//    NSDictionary* userInfo = [NSDictionary dictionaryWithObjectsAndKeys:self.tagName.text, NOTIFICATION_ADDNEWTAG_LABELNAME, nil];
//	
//	NSNotification* notification = [NSNotification notificationWithName:NOTIFICATION_JZBDATACHANGED 
//																 object:self 
//															   userInfo:userInfo];
//	
//	[[NSNotificationCenter defaultCenter] postNotification:notification];
//	
//}

//start an update thread. If there is another updating thread, current thread should be waiting
+(void)startUpdating{
    [[self locker] lock];
}

//declare that current thread is finished updating
+(void)endUpdating{
    [[self locker] unlock];
}

//-(id)init{
//    if (self = [super init]){
//        if (!updating){
//             updating = [[NSLock alloc] init];
//        }
//    }
//    
//    return self;
//}

//-(void)dealloc{
////    [self.addedObjects release];
////    [self.modifiedObjects release];
////    [self.deletedObjects release];
//    [super dealloc];
//}

@end

@implementation JZBDataAccessManager (private)

//fetch all instances using given model name, with it’s property name and value
+(NSArray*)getInstancesWithModelName:(NSString*)modelName 
                           predicate:(NSPredicate*)predicate{
    NSFetchedResultsController* fetchedResults = [JJObjectManager fetchedResultsControllerFromModel:modelName predicate:predicate sortDescriptors:[NSArray arrayWithObjects:nil] context:nil];
    NSError* error = nil;
    [fetchedResults performFetch:&error];
    NSArray* result = nil;
    if (!error){
        result = [fetchedResults fetchedObjects];
    }
    return result;
}

+(NSMutableArray*)deletedObjects{
    if (!deletedObjects){
        deletedObjects = [NSMutableArray arrayWithCapacity:0];
    }
    
    return deletedObjects;
}

+(NSMutableArray*)addedObjects{
    if (!addedObjects){
        addedObjects = [NSMutableArray arrayWithCapacity:0];
    }
    
    return addedObjects;
}

+(NSMutableArray*)modifiedObjects{
    if (!modifiedObjects){
        modifiedObjects = [NSMutableArray arrayWithCapacity:0];
    }
    
    return modifiedObjects;
}

+(NSLock*)locker{
    if (!updating){
        updating = [[NSLock alloc] init];
    }
    
    return updating;
}

@end
