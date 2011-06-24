//
//  JZBSynchronizer.h
//  JZB
//
//  Created by Jin Jin on 11-3-31.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

//used to synchronize stored data with remote server

#import <Foundation/Foundation.h>
#import "JZBDataChangeUnit.h"
#import "JZBSyncRequest.h"
#import "JJObjectManager.h"

typedef enum {
    JZBSyncStart,
    JZBSyncEnd,
    JZBSyncError
} JZBSyncNotificationType;

@interface JZBSynchronizer : NSObject<JZBSyncRequestDelegate> {
    JZBSyncRequest* _syncRequest;
    NSDictionary* _modelNamesForTables;
    NSDictionary* _primaryKeysForTables;
}

@property (nonatomic, retain) JZBSyncRequest* syncRequest;
@property (nonatomic, retain) NSDictionary* modelNamesForTables;
@property (nonatomic, retain) NSDictionary* primaryKeysForTables;

//add local change to the pool
+(BOOL)addLocalChange:(JZBDataChangeUnit*)change;
//add local delete to the pool
+(BOOL)addLocalDelete:(NSString*)tableName key:(NSString*)key;
//add remote change to the pool
+(BOOL)addRemoteChange:(JZBDataChangeUnit*)change;
//add remote delete to the pool
+(BOOL)addRemoteDelete:(NSString*)tableName key:(NSString*)key;
//method to sync change
-(BOOL)syncChangeTryToLock:(BOOL)tryLock;

@end

@interface JZBSynchronizer (private)

//begin uploading operation
-(BOOL)beginUploadingWithTry:(BOOL)tryLock;
//end uploading operation
-(void)commitUploading;

//begin sync operation
-(BOOL)beginSyncWithTry:(BOOL)tryLock;
//end sync operation
-(void)commitSync;

-(void)commitDownloadedData:(NSString*)str;

-(void)sendNotification:(JZBSyncNotificationType)type error:(NSError*)error;

@end


