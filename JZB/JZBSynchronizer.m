//
//  JZBSynchronizer.m
//  JZB
//
//  Created by Jin Jin on 11-3-31.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "JZBSynchronizer.h"
#import "JZBDataChangeJSON.h"
#import "JZBDataChangeUnit.h"
#import "JZBManagedObject.h"
#import "JZBDataAccessManager.h"

@implementation JZBSynchronizer

@synthesize syncRequest = _syncRequest;
@synthesize modelNamesForTables = _modelNamesForTables;
@synthesize primaryKeysForTables = _primaryKeysForTables;

//stores all local change/delete that happens in iPhone
static NSMutableDictionary* _localChange = nil;
static NSMutableArray* _localDelete = nil;
//stores all remote cahnge/delete that downloaded from remote server
static NSMutableDictionary* _remoteChange = nil;
static NSMutableArray* _remoteDelete = nil;

//locks for all changes
static NSLock* _localLock = nil;
static NSLock* _remoteLock = nil;

static JZBSynchronizer* _defaultSynchronizer = nil;

-(NSLock*)getLocalLock{
    if (!_localLock){
        _localLock = [[NSLock alloc] init];
    }
    
    return _localLock;
}

-(NSLock*)getRemoteLock{
    if (!_remoteLock){
        _remoteLock = [[NSLock alloc] init];
    }
    
    return _remoteLock;
}

-(NSMutableDictionary*)getLocalChange{
    if (!_localChange){
        _localChange = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    return _localChange;
}

-(NSMutableArray*)getLocalDelete{
    if (!_localDelete){
        _localDelete = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _localDelete;
}

-(NSMutableDictionary*)getRemoteChange{
    if (!_remoteChange){
        _remoteChange = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    return _remoteChange;
}

-(NSMutableArray*)getRemoteDelete{
    if (!_remoteDelete){
        _remoteDelete = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _remoteDelete;
}

-(BOOL)addLocalChange:(JZBDataChangeUnit*)changeUnit{
    [self.localLock lock];
    //talbe name is the key for change pool
    JZBDataChangeUnit* tableChange = [self.localChange valueForKey:changeUnit.tableName];
    //if no change for this table was added before, create a new empty list and add to the pool
    if (!tableChange){
        [self.localChange setValue:changeUnit forKey:changeUnit.tableName];
    }else{
        [tableChange mergeChangeData:changeUnit];
    }
    
    [self.localLock unlock];
    return YES;
}

-(BOOL)addLocalDeleteForTable:(NSString *)tableName keyValue:(NSString *)key{
    [self.localLock lock];
    NSArray* deleteUnit = [NSArray arrayWithObjects:tableName, key, nil];
    [self.localDelete addObject:deleteUnit];
    [self.localLock unlock];
    return YES;
}

-(BOOL)addRemoteChange:(JZBDataChangeUnit*)changeUnit{
    [self.remoteLock lock];
    //talbe name is the key for change pool
    NSMutableArray* changeList = [self.remoteChange valueForKey:changeUnit.tableName];
    //if no change for this table was added before, create a new empty list and add to the pool
    if (!changeList){
        NSMutableArray* tempList = [[NSMutableArray alloc] initWithCapacity:0];
        [self.remoteChange setObject:changeUnit forKey:tempList];
        changeList = tempList;
        [tempList release];
    }
    
    //add the change unit to list
    [changeList addObject:changeUnit];
    [self.remoteLock unlock];
    return YES;
}

-(BOOL)addRemoteDeleteForTable:(NSString*)tableName keyValue:(NSString*)key{
    [self.remoteLock lock];
    NSArray* deleteUnit = [NSArray arrayWithObjects:tableName, key, nil];
    [self.remoteDelete addObject:deleteUnit];
    [self.remoteLock unlock];
    return YES;
}

-(BOOL)syncChangeTryToLock:(BOOL)tryLock;{
    if (![self beginSyncWithTry:tryLock]){//if failed try lock
        return NO;
    }
    //send notification for sync start
    [self sendNotification:JZBSyncStart error:nil];
    //do uploading
    
    JZBDataChangeJSON* wholeChange = [[JZBDataChangeJSON alloc] initWithChange:self.localChange
                                                                     andDelete:self.localDelete];
    
    NSString* JSONString = [wholeChange JSON];
    [wholeChange release];
    DebugLog(@"JSON string to be uploaded is %@", JSONString);
    //upload JSONString asynchronized
    
    self.syncRequest.syncTables = JSONString;
    [self.syncRequest start];
    return YES;
}

//delegate method
-(void)didFinishedSyncWithReturn:(NSString*)ret{
    
    [self commitDownloadedData:ret];
    //send out sync end notification
    [self sendNotification:JZBSyncEnd error:nil];
    //finished sync, unlock lock and commit change
    [self commitSync];
}

-(void)didFailedWithError:(NSError*)error{
    //send out sync error notification
    [self sendNotification:JZBSyncError error:error];
    //finished sync with error, unlock lock and commit change
    [self commitSync];
}

+(JZBSynchronizer*)defaultSynchronizer{
    if (!_defaultSynchronizer){
        _defaultSynchronizer = [[JZBSynchronizer alloc] init];
    }
    
    return _defaultSynchronizer;
}

-(id)init{
    self = [super init];
    if (self){
        //init static object if it's nil
        
        if (!_localChange){
            _localChange = [[NSMutableDictionary alloc] initWithCapacity:0];
        }
        
        if (!_localDelete){
            _localDelete = [[NSMutableArray alloc] initWithCapacity:0];
        }
        
        if (!_remoteChange){
            _remoteChange = [[NSMutableDictionary alloc] initWithCapacity:0];
        }
        
        if (!_remoteDelete){
            _remoteDelete = [[NSMutableArray alloc] initWithCapacity:0];
        }
        
        JZBSyncRequest* req = [[JZBSyncRequest alloc] init];
        req.delegate = self;
        self.syncRequest = req;
        [req release];
        
        //load primary key name mapping and model name mapping from bundle files
        NSString* pathPK = [[NSBundle mainBundle] pathForResource:BUNDLENAME_PKFORTABLES 
                                                           ofType:@"plist"];
        NSString* pathModelName = [[NSBundle mainBundle] pathForResource:BUNDLENAME_MODELNAMEFORTABLES 
                                                                  ofType:@"plist"];
        self.primaryKeysForTables = [NSDictionary dictionaryWithContentsOfFile:pathPK];
        self.modelNamesForTables = [NSDictionary dictionaryWithContentsOfFile:pathModelName];
    }
    
    return self;
}

-(void)dealloc{
    [self.syncRequest release];
    [self.modelNamesForTables release];
    [self.primaryKeysForTables release];
    [super dealloc];
}

@end

@implementation JZBSynchronizer (private)

//begin uploading operation
-(BOOL)beginUploadingWithTry:(BOOL)tryLock{
    if (tryLock){
        if (![self.localLock tryLock]){//if it's been locked
            return NO;
        }
    }else{
        [self.localLock lock];
    }
    
    return YES;
}
//end uploading operation
-(void)commitUploading{
    //commit uploaded change
    //remove all local change after finishing uploading
    [self.localChange removeAllObjects];
    [self.localDelete removeAllObjects];
    [self.localLock unlock];
}

//begin sync operation
-(BOOL)beginSyncWithTry:(BOOL)tryLock{
    if (![self beginUploadingWithTry:tryLock]){//if failed to try lock
        return NO;
    }
    //send out notificaion for sync start
    return YES;
//    [self beginDownloading];
    
}
//end sync operation
-(void)commitSync{
//    [self commitDownloading];
    [self commitUploading];
    
}

//commint the downloaded JSON string to DB
-(void)commitDownloadedData:(NSString*)str{
    //create a JSON object using downloaded string
    JZBDataChangeJSON* downloadedChange = [[JZBDataChangeJSON alloc] initWithJSONMessage:str];
    //get two new contexts for both delete and change operation
    NSManagedObjectContext* deleteContext = [JJObjectManager context];
    NSManagedObjectContext* changeContext = [JJObjectManager context];
    
    //fetch objects for deletion
    for (NSArray* deleteUnit in downloadedChange.trashes){
        //delete all object in downloadedChange.trashed
        if ([deleteUnit count] == 2){
            //table name is in the index 0
            NSString* tableName = [deleteUnit objectAtIndex:0];
            //ID value is in the index 1
            NSString* ID = [deleteUnit objectAtIndex:1];//ID...every object has different ID name...
            //get model name from mapping
            NSString* modelName = [self.modelNamesForTables objectForKey:tableName];
            //get primary key name from key name mapping
            NSString* primaryKey = [self.primaryKeysForTables objectForKey:tableName];
            NSArray* fetchResult = [JJObjectManager objectsByModelName:modelName 
                                                               withKey:primaryKey
                                                              andValue:ID 
                                                               context:deleteContext];
            for (JZBManagedObject* obj in fetchResult){
                [JZBDataAccessManager deleteSingleObject:obj];
            }
        }
    }
    
    //There will be one change unit for one table. All changes are included
    for (JZBDataChangeUnit* changeUnit in downloadedChange.syncTables){
        //modify or add all change in downloadedChange.syncTables
        int keyValueTag = 0;
        //get model name from name mapping
        NSString* modelName = [self.modelNamesForTables objectForKey:changeUnit.tableName];
        for (int i = 0; i<[changeUnit.columns count]; i++){
            //find location of primary key value
            if ([[changeUnit.columns objectAtIndex:i] isEqualToString:changeUnit.primaryKey]){
                keyValueTag = i;
            }
        }
        //process every group change data
        for (NSArray* dataUnit in changeUnit.data){
            //get the key value
            NSString* keyValue = [dataUnit objectAtIndex:keyValueTag];
            NSArray* fetchResult = [JJObjectManager objectsByModelName:modelName 
                                                               withKey:changeUnit.primaryKey 
                                                              andValue:keyValue 
                                                               context:changeContext];
            if ([fetchResult count]){//find a record, that means modify
                for (NSManagedObject* obj in fetchResult){
                    //save the change
                    [(JZBManagedObject*)obj setValues:dataUnit
                                           forColumns:changeUnit.columns];
                }
            }else{//not find, means add new object
                NSManagedObject* obj = [JJObjectManager newManagedObjectWithModelName:modelName 
                                                                              context:changeContext];
                [(JZBManagedObject*)obj setValues:dataUnit
                                       forColumns:changeUnit.columns];
            }
        }
        
    }
    //commit contexts
    [JJObjectManager commitChangeForContext:deleteContext];
    [JJObjectManager commitChangeForContext:changeContext];
    
    [downloadedChange release];
}

-(void)sendNotification:(JZBSyncNotificationType)type error:(NSError*)error{
    NSString* name = nil;
    id obj = nil;
    switch (type) {
        case JZBSyncStart:
            name = NOTIFICATION_SYNC_START;
            break;
        case JZBSyncError:
            name = NOTIFICATION_SYNC_ERROR;
            obj = error;
            break;
        case JZBSyncEnd:
            name = NOTIFICATION_SYNC_END;
            break;
        default:
            break;
    }
    
    NSNotification* notification = [NSNotification notificationWithName:name object:obj];
    
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

@end
