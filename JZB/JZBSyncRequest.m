//
//  JZBSyncRequest.m
//  JZB
//
//  Created by Jin Jin on 11-4-4.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "JZBSyncRequest.h"

#define REQUEST_METHOD_POST @"POST"

#define FIELD_APP_KEY       @"app_key"
#define FIELD_APP_SECRET    @"app_secret"
#define FIELD_VERSION       @"version"
#define FIELD_USERNAME      @"username"
#define FIELD_PASSWORD      @"password"
#define FIELD_SYNC_TIME     @"sync_time"
#define FIELD_CLIENT_TIME   @"client_time"
#define FIELD_SYNC_TABLES   @"sync_tables"
//it's a fixed value
#define VALUE_APP_KEY       @"20001"
//it's a fixed value
#define VALUE_APP_SECRET    @"078AA887C16F40E7A68852E912DA27CF"
//this value should be changed for every new release, synced with app's version number
#define VALUE_VERSION       @"1.0.0" 

//上传的地址
#define URLSTRING_UPLOADING @"http://www.jzben.com/sync/ios.php"
//下载的地址
#define URLSTRING_DOWNLOADING @"http://www.jzben.com/sync/ios.php"
//URL string for sync
#define URLSTRING_SYNC @"http://www.jzben.com/sync/ios.php"

@implementation JZBSyncRequest

@synthesize syncTables = _syncTables;
@synthesize parameters = _parameters;
@synthesize request = _request;
@synthesize delegate = _delegate;
@synthesize connection = _connection;
@synthesize cacheData = _cacheData;

//start sync
-(void)start{
    NSURLConnection* connection = [NSURLConnection connectionWithRequest:self.request 
                                                                delegate:self];
    [connection start];
}

-(void)done{
    //save the current time as sync time
    NSDate* now = [NSDate date];
    [[NSUserDefaults standardUserDefaults] setObject:now forKey:FIELD_SYNC_TIME];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)setSyncTablesToRequest:(NSString*)mSyncTables{
    if (_syncTables != mSyncTables){
        [_syncTables release];
        _syncTables = mSyncTables;
        [_syncTables retain];
        if (!_syncTables){
            [self.parameters setParameterForKey:FIELD_SYNC_TABLES
                                      withValue:_syncTables];
        }
    }
}

-(NSURLRequest*)getRequest{
    NSDate* client_time = [NSDate date];
    [self.parameters setParameterForKey:FIELD_CLIENT_TIME
                              withValue:[client_time description]];
    [_request setHTTPBody:[[self.parameters parameterString] dataUsingEncoding:NSUTF8StringEncoding]];
    
    return _request;
}

//delegate methodes

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    NSString* receivedString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [self.cacheData appendString:receivedString];
    [receivedString release];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    [self.delegate didFinishedSyncWithReturn:self.cacheData];
    self.cacheData = [NSMutableString stringWithCapacity:0];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    [self.delegate didFailedWithError:error];
    self.cacheData = [NSMutableString stringWithCapacity:0];
}

//init and dealloc
-(id)init{
    if (self = [super init]){
        
        self.request = [NSURLRequest requestWithURL:[NSURL URLWithString:URLSTRING_SYNC]];
        [self.request setHTTPMethod:REQUEST_METHOD_POST];
        URLParameterSet* param = [[URLParameterSet alloc] init];
        self.parameters = param;
        [param release];
        
        NSString* username = [[NSUserDefaults standardUserDefaults] stringForKey:FIELD_USERNAME];
        NSString* password = [[NSUserDefaults standardUserDefaults] stringForKey:FIELD_PASSWORD];
        NSDate* sync_time = [[NSUserDefaults standardUserDefaults] objectForKey:FIELD_SYNC_TIME];
        
        //if sync time is nil, use a distant past time
        if (!sync_time){
            sync_time = [NSDate distantPast];
        }
        
        //set value for request paramters
        [self.parameters setParameterForKey:VALUE_APP_KEY 
                                  withValue:FIELD_APP_KEY];
        [self.parameters setParameterForKey:VALUE_APP_SECRET
                                  withValue:FIELD_APP_KEY];
        [self.parameters setParameterForKey:VALUE_VERSION
                                  withValue:FIELD_VERSION];
        [self.parameters setParameterForKey:FIELD_USERNAME
                                  withValue:username];
        [self.parameters setParameterForKey:FIELD_PASSWORD
                                  withValue:password];
        [self.parameters setParameterForKey:FIELD_SYNC_TIME
                                  withValue:[sync_time description]];
            
        self.cacheData = [NSMutableString stringWithCapacity:0];
    }
        
    return self;
}


-(void)dealloc{
    [self.parameters release];
    [self.request release];
    [self.syncTables release];
    [self.connection release];
    [self.cacheData release];
    [super dealloc];
}

@end
