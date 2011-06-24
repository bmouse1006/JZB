//
//  JZBSyncRequest.h
//  JZB
//
//  Created by Jin Jin on 11-4-4.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "URLParameterSet.h"

@protocol JZBSyncRequestDelegate

-(void)didFinishedSyncWithReturn:(NSString*)ret;
-(void)didFailedWithError:(NSError*)error;

@end

@interface JZBSyncRequest : NSObject {
    NSString* _syncTables;
    URLParameterSet* _parameters;
    
    NSMutableURLRequest* _request;
    NSURLConnection* _connection;
    
    id<JZBSyncRequestDelegate> _delegate;
    
    NSMutableString* _cacheData;
}

@property (nonatomic, retain, setter = setSyncTablesToRequest:) NSString* syncTables;
@property (nonatomic, retain, getter = getRequest) NSMutableURLRequest* request;
@property (nonatomic, retain) NSURLConnection* connection;
@property (nonatomic, retain) URLParameterSet* parameters;
@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) NSMutableString* cacheData;

-(void)setSyncTablesToRequest:(NSString*)syncTables;

-(void)start;
-(void)done;

@end
