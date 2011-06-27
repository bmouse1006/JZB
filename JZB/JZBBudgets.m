//
//  JZBBudgets.m
//  JZB
//
//  Created by Jin Jin on 11-4-5.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "JZBBudgets.h"

@implementation JZBBudgets
@dynamic budget_id;
@dynamic start_date;
@dynamic end_date;
@dynamic desc;

-(id)getKeyValue{
    return self.budget_id;
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
        if ([column isEqualToString:@"description"]){
            column = @"desc";
        }else if ([column isEqualToString:@"start_date"]){
            type = JZBDataTypeDate;
        }else if ([column isEqualToString:@"end_date"]){
            type = JZBDataTypeDate;
        }
        [self setValue:value forKey:column type:type];
    }
    
    return YES;
}

-(id)init{
    if (self = [super init]){
        if (!self.budget_id){
            self.budget_id = [self stringForObjectID];
        }
    }
    
    return self;
}

@end
