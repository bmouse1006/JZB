//
//  JZBDataChangeJSON.h
//  JZB
//
//  Created by Jin Jin on 11-4-1.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface JZBDataChangeJSON : NSObject {
    NSMutableArray* _trashes;
    NSMutableArray* _syncTables;
    NSString* _JSONString;
}

@property (nonatomic, retain) NSMutableArray* trashes;
@property (nonatomic, retain) NSMutableArray* syncTables;
@property (nonatomic, retain) NSString* JSONString;

//init JZBDataChangeJSON obj with incoming JSON message
-(id)initWithJSONMessage:(NSString*)msg;
//init JZBDataChangeJSON obj with change and delete
-(id)initWithChange:(NSDictionary*)change andDelete:(NSArray*)del;

-(BOOL)commitChange;
//Get JSON message based on current instance
-(NSString*)JSON;

@end

@interface JZBDataChangeJSON (private)

-(NSString*)trashesJSON;
-(NSString*)syncTablesJSON;

@end
