//
//  JZBDataChangeJSON.m
//  JZB
//
//  Created by Jin Jin on 11-4-1.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "JZBDataChangeJSON.h"
#import "JZBDataChangeUnit.h"
#import "JSON.h"

#define JSONKEY_TRASHES     @"Trashes"
#define JSONKEY_SYNCTABLES  @"SyncTables"
#define JSONTEMPLATE        @"{\"Trashes\":[%@],\"SyncTables\":[%@]}"
#define JSONTRASHESTEMPLATE @"[%@,%@]"
#define JSONSYNCTABLETEMPLATE @""

@implementation JZBDataChangeJSON

@synthesize trashes = _trashes;
@synthesize syncTables = _syncTables;
@synthesize JSONString = _JSONString;

-(id)initWithJSONMessage:(NSString*)msg{
    if (self = [super init]){
        self.trashes = [NSMutableArray arrayWithCapacity:0];
        self.syncTables = [NSMutableArray arrayWithCapacity:0];
        self.JSONString = msg;
        
        NSDictionary* JSONObj = [self.JSONString JSONValue];
        NSArray* keys = [JSONObj allKeys];
        
        for(NSString* key in keys){
            NSObject* value = [JSONObj objectForKey:key];
            //for trashes
            if ([key isEqualToString:JSONKEY_TRASHES]){
                for (id unit in (NSArray*)value){
                    [self.trashes addObject:unit];
                }
            }
            //for sync tables
            if ([key isEqualToString:JSONKEY_SYNCTABLES]){
                if ([value isKindOfClass:[NSArray class]]){
                    for (NSObject* unit in (NSArray*)value){
                        JZBDataChangeUnit* changeUnit = [[JZBDataChangeUnit alloc] initWithJSONObj:unit type:JZBDataChangeTypeLocalSync];
                        [self.syncTables addObject:changeUnit];
                        [changeUnit release];
                    }
                }
            }

        }
        
    }
    
    return self;
}

-(id)initWithChange:(NSDictionary*)change andDelete:(NSArray*)del{
    if (self = [super init]){
        self.trashes = [NSMutableArray arrayWithArray:del];
        self.syncTables = [NSMutableArray arrayWithCapacity:0];
        NSArray* changeList = [change allValues];
        for (JZBDataChangeUnit* unit in changeList){
            [self.syncTables addObject:unit];
        }
    }
    
    return self;
}

-(NSString*)JSON{
    NSString* JSONString = [NSString stringWithFormat:JSONTEMPLATE, [self trashesJSON], [self syncTablesJSON]];
    
    return JSONString;
}

-(BOOL)commitChange{
    return YES;
}

-(void)dealloc{
    [self.trashes release];
    [self.syncTables release];
    [self.JSONString release];
    [super dealloc];
}

@end

@implementation JZBDataChangeJSON (private)

//generate JSON string for trashes
-(NSString*)trashesJSON{
    NSMutableString* JSONString = [NSMutableString stringWithFormat:@""];
    int flag = 0;
    for (NSArray* unit in self.trashes){
        if ([unit count] == 2){
            NSString* tableName = [unit objectAtIndex:0];
            NSString* keyValue = [unit objectAtIndex:1];
            if (flag != 0){
                [JSONString appendFormat:@","];
            }
            [JSONString appendFormat:JSONTRASHESTEMPLATE, tableName, keyValue];
        }
        flag = 1;
    }
    
    return JSONString;
}

//generate JSON string for sync tables
-(NSString*)syncTablesJSON{
    NSMutableString* JSONString = [NSMutableString stringWithFormat:@""];
    int flag = 0;
    for (JZBDataChangeUnit* changeUnit in self.syncTables){
        if (flag != 0){
            [JSONString appendFormat:@","];
        }
        
        [JSONString appendString:[changeUnit JSON]];
        
        flag = 1;
    }

    return JSONString;
}

@end
