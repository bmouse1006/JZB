//
//  JZBBills.m
//  JZB
//
//  Created by Jin Jin on 11-4-5.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "JZBBills.h"
#import "JJObjectManager.h"

@implementation JZBBills
@dynamic amount;
@dynamic bill_id;
@dynamic to_account_id;
@dynamic catalog_id;
@dynamic title;
@dynamic month;
@dynamic date;
@dynamic borrower_id;
@dynamic kind;
@dynamic version;
@dynamic account_id;
@dynamic desc;

//provide all keys for properties
-(NSArray*)allKeysForValues{
    NSArray* keys = [NSArray arrayWithObjects:@"amount", @"bill_id", @"to_account_id", @"catalog_id", @"title", @"month", @"date", @"borrower_id", @"kind", @"version", @"account_id", @"desc", nil];
    
    return keys;
}

-(id)getKeyValue{
    return self.bill_id;
}

-(BOOL)setValues:(NSArray*)values forColumns:(NSArray*)columns{
    //if the two arrays contains different count of items, return false
    if ([values count] != [columns count]){
        return NO;
    }
    
    int count = [columns count];
    
    for (int i = 0; i < count; i++){
        NSString* column = [columns objectAtIndex:i];
        NSString* value = [values objectAtIndex:i];
        //catelog_id is an exception. It's a typo in remote DB
        JZBDataType type = JZBDataTypeString;
        if ([column isEqualToString:@"catelog_id"]){
            column = @"catalog_id";
        }else if ([column isEqualToString:@"sub_catelog_id"]){
            column = @"sub_catalog_id";
        }else if ([column isEqualToString:@"amount"]){
            type = JZBDataTypeDouble;
        }else if ([column isEqualToString:@"month"]){
            type = JZBDataTypeInt;
        }else if ([column isEqualToString:@"date"]){
            type = JZBDataTypeDate;
        }else if ([column isEqualToString:@"version"]){
            type = JZBDataTypeDate;
        }
        [self setValue:value forKey:column type:type];
    }
    return YES;
}

-(NSArray*)objectsForID:(NSString*)ID{
    return [JJObjectManager objectsByModelName:@"JZBBills" withKey:@"bill_id" andValue:ID];
}

-(NSArray*)objectsForName:(NSString*)name{
    return [JJObjectManager objectsByModelName:@"JZBBills" withKey:@"title" andValue:name];
}

//get names for columns
-(NSArray*)columns{
    //nothing here
    NSArray* columns = [NSArray arrayWithObjects:@"amount", @"month", @"bill_id", @"to_account_id", @"catalog_id", @"title", @"date", @"version", @"borrower_id", @"kind", @"account_id", @"description", nil];
    return columns;
}
//get data for columns
-(NSArray*)data{
    //string can't be nil object
    //set it as empty string if it's nil
    NSString* amount = (self.amount)?[self.amount stringValue]:@"";
    NSString* month = (self.month)?[self.month stringValue]:@"";
    NSString* bill_id = (self.bill_id)?self.bill_id:@"";
    NSString* to_account_id = (self.to_account_id)?self.to_account_id:@"";
    NSString* catalog_id = (self.catalog_id)?self.catalog_id:@"";
    NSString* title = (self.title)?self.title:@"";
    NSString* date = (self.date)?[self.date description]:@"";
    NSString* version = (self.version)?[self.version description]:@"";
    NSString* borrower_id = (self.borrower_id)?self.borrower_id:@"";
    NSString* kind = (self.kind)?self.kind:@"";
    NSString* account_id = (self.account_id)?self.account_id:@"";
    NSString* description = (self.desc)?self.desc:@"";
    
    return [NSArray arrayWithObjects:amount, month, bill_id, to_account_id, catalog_id, title, date, version, borrower_id, kind, account_id, description, nil];
    //nothing here
}


-(NSString*)description{
    NSMutableString* des = [NSMutableString stringWithCapacity:0];
    [des appendFormat:@"amount: %@\n", [self.amount description]];
    [des appendFormat:@"bill_id: %@\n", [self.bill_id description]];
    [des appendFormat:@"to_account_id: %@\n", [self.to_account_id description]];
    [des appendFormat:@"catalog_id: %@\n", [self.catalog_id description]];
    [des appendFormat:@"title: %@\n", [self.title description]];
    [des appendFormat:@"month: %@\n", [self.month description]];
    [des appendFormat:@"date: %@\n", [self.date description]];
    [des appendFormat:@"borrower_id: %@\n", [self.borrower_id description]];
    [des appendFormat:@"kind: %@\n", [self.kind description]];
    [des appendFormat:@"version: %@\n", [self.version description]];
    [des appendFormat:@"account_id: %@\n", [self.account_id description]];
    [des appendFormat:@"desc: %@\n", [self.desc description]];
    
    return des;
}

-(id)init{
    if (self = [super init]){
        if (!self.bill_id){
            self.bill_id = [self stringForObjectID];
        }
    }
    
    return self;
}

@end
