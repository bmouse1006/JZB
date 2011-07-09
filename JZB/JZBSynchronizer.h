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

    BOOL _isSyncing;
}

@property (nonatomic, retain) JZBSyncRequest* syncRequest;
@property (nonatomic, retain) NSDictionary* modelNamesForTables;
@property (nonatomic, retain) NSDictionary* primaryKeysForTables;
@property (nonatomic, readonly, getter = getLocalLock) NSLock* localLock;
@property (nonatomic, readonly, getter = getRemoteLock) NSLock* remoteLock;
@property (nonatomic, readonly, getter = getUploadingLock) NSLock* uploadingLock;
@property (nonatomic, readonly, getter = getLocalChange) NSMutableDictionary* localChange;
@property (nonatomic, readonly, getter = getLocalDelete) NSMutableArray* localDelete;
@property (nonatomic, readonly, getter = getRemoteChange) NSMutableDictionary* remoteChange;
@property (nonatomic, readonly, getter = getRemoteDelete) NSMutableArray* remoteDelete;

@property (nonatomic, readonly, getter = getStagingChange) NSMutableDictionary* stagingChange;
@property (nonatomic, readonly, getter = getStagingDelete) NSMutableArray* stagingDelete;

@property (nonatomic, assign) BOOL isSyncing;

//return the default synchronizer
+(JZBSynchronizer*)defaultSynchronizer;
//add local change to the pool
-(BOOL)addLocalChange:(JZBDataChangeUnit*)change;
//add local delete to the pool
-(BOOL)addLocalDeleteForTable:(NSString *)tableName keyValue:(NSString *)key;
//add remote change to the pool
-(BOOL)addRemoteChange:(JZBDataChangeUnit*)change;
//add remote delete to the pool
-(BOOL)addRemoteDeleteForTable:(NSString*)tableName keyValue:(NSString*)key;
//method to sync change
-(BOOL)syncChangeTryToLock:(BOOL)tryLock;
//store the current local change queue to plist files
-(void)saveCurrentLocalChange;
//restore current local change queue from plist files and resume sync process if any
-(void)loadCurrntLocalChange;

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
//roll back sync operation if failed
-(void)rollbackSync;

-(void)commitDownloadedData:(NSString*)str;

-(void)sendNotification:(JZBSyncNotificationType)type error:(NSError*)error;

//get file path
-(NSString*)storePath;

@end


