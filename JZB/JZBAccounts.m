//
//  JZBAccounts.m
//  JZB
//
//  Created by Jin Jin on 11-4-5.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "JZBAccounts.h"
#import "JJObjectManager.h"

@implementation JZBAccounts
@dynamic amount;
@dynamic sort;
@dynamic account_id;
@dynamic version;
@dynamic kind;
@dynamic name;
@dynamic desc;

+(NSArray*)objectsForName:(NSString*)name{
    return [self objectsForKey:@"name" andValue:name];
}

-(id)getKeyValue{
    return self.account_id;
}

//check if two accounts are the same
-(BOOL)isEqualToManagedObject:(JZBManagedObject*)object{
    JZBAccounts* target = (JZBAccounts*)object;
    BOOL result = NO;
    if (target != nil){
        if (self.account_id != nil && target.account_id != nil){
            result = [self.account_id isEqualToString:target.account_id];
        }
    }
    
    return result;
}

-(void)setupDefaultValues{
    self.account_id = [self stringForObjectID];
    self.kind = ACCOUNT_KIND_CASH;
    self.version = [NSDate date];
    self.sort = [NSNumber numberWithInt:1];
}

-(NSArray*)objectsForID:(NSString*)ID{
    return [JJObjectManager objectsByModelName:[[self class] modelName] withKey:@"account_id" andValue:ID];
}

-(NSArray*)objectsForName:(NSString*)name{
    return [JJObjectManager objectsByModelName:[[self class] modelName] withKey:@"name" andValue:name];
}

//get names for columns
-(NSArray*)columns{
    //nothing here
  
    NSArray* columns = [NSArray arrayWithObjects:@"amount", @"sort", @"account_id", @"version", @"kind", @"name", @"description", nil];
    return columns;
}
//get data for columns
-(NSArray*)data{
    //string can't be nil object
    //set it as empty string if it's nil

    NSString* amount = (self.amount)?[self.amount stringValue]:@"";
    NSString* sort = (self.sort)?[self.sort stringValue]:@"";
    NSString* account_id = (self.account_id)?self.account_id:@"";
    NSString* version = (self.version)?[self.version description]:@"";
    NSString* kind = (self.kind)?self.kind:@"";
    NSString* name = (self.name)?self.name:@"";
    NSString* description = (self.desc)?self.desc:@"";
    
    return [NSArray arrayWithObjects:amount, sort, account_id, version, kind, name, description, nil];

    //nothing here
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
        JZBDataType type = JZBDataTypeString;
        if ([column isEqualToString:@"amount"]){
            type = JZBDataTypeDouble;
        }else if ([column isEqualToString:@"sort"]){
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

-(id)init{
    self = [super init];
    if (self){
        if (!self.account_id){
            self.account_id = [self stringForObjectID];
            self.kind = ACCOUNT_KIND_CASH;
        }
    }
    
    return self;
}

@end
