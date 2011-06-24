//
//  JZBDataAccessManager.h
//  JZB
//
//  Created by Jin Jin on 11-3-30.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "/usr/include/sqlite3.h"

//define a notification for data changing
#define NOTIFICATION_JZBDATACHANGED @"NOTIFICATION_JZBDATACHANGED"
#define NOTIFICATION_JZBDATACHAGNED_

#define ACCOUNTMODELNAME    @"JZBAccounts"
#define BILLMODELNAME       @"JZBBillModel"
#define BORROWERSMODELNAME  @"JZBBorrowers"
#define CATALOGSMODELNAME   @"JZBCatalogs"
#define BUDGETMODELNAME     @"JZBBudgets"
#define BUDGETITEMMODELNAME @"JZBBudgetItems"

@interface JZBDataAccessManager : NSObject {
    //object pool to record changes, including delete/modify/add
//    NSDictionary* _deletedObjects;
//    NSDictionary* _modifiedObjects;
//    NSDictionary* _addedObjects;
    
//    sqlite3* _database;
}

//@property (retain) NSDictionary* deletedObjects;
//@property (retain) NSDictionary* modifiedObjects;
//@property (retain) NSDictionary* addedObjects;

//multi thread mutex should be considered for all data change message
//core data already considered about this. We don't need to implement it manually
+(NSArray*)getAllBills;
+(NSArray*)getBillsByAccount:(NSString*)accountID;
+(NSArray*)getBillsByCatalog:(NSString*)catalogID;
+(NSArray*)getBillsBetweenStartDate:(NSDate*)startDate andEndDate:(NSDate*)endDate byAccountID:(NSString*)accountID;

+(NSArray*)getBillsByPredicate:(NSPredicate*)predicate;
+(BOOL)saveBills:(NSArray*)bills;
+(BOOL)deleteBills:(NSArray*)bills;
+(NSArray*)getAllCatalogs;
+(BOOL)saveCatalogs:(NSArray*)catalogs;
+(BOOL)deleteCatalogs:(NSArray*)catalogs;
+(NSArray*)getAllAccounts;
+(BOOL)saveAccounts:(NSArray*)accounts;
+(BOOL)deleteAccounts:(NSArray*)accounts;
+(NSArray*)getAllBorrowers;
+(BOOL)saveBorrowers:(NSArray*)borrowers;
+(BOOL)deleteBorrowers:(NSArray*)borrowers;
+(NSArray*)getAllBudgets;
+(BOOL)saveBudgets:(NSArray*)budgets;
+(BOOL)deleteBudgets:(NSArray*)budgets;
+(NSArray*)getBudgetItemsByBudgetID:(NSString*)budgetID;
+(BOOL)saveBudgetItems:(NSArray*)budgetItems;
+(BOOL)deleteBudgetItems:(NSArray*)budgetItems;

//fetch result by SQL leaguage
+(NSArray*)fetchResultBySQL:(NSString*)sqlquery;

//let sync modal know that there is something changed, content of changing is included in notification
//+(void)sendChangedNotification:(NSNotification*)notification;
//start an update thread. If there is another updating thread, current thread should be waiting
+(void)startUpdating;
//declare that current thread is finished updating
+(void)endUpdating;

@end

@interface JZBDataAccessManager (private)

//fetch all instances using given model name, with it’s property name and value
+(NSArray*)getInstancesWithModelName:(NSString*)modelName predicate:(NSPredicate*)predicate;
+(NSLock*)locker;
+(NSMutableArray*)deletedObjects;
+(NSMutableArray*)addedObjects;
+(NSMutableArray*)modifiedObjects;

@end