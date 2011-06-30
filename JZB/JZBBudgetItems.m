//
//  JZBBudgetItems.m
//  JZB
//
//  Created by Jin Jin on 11-4-5.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "JZBBudgetItems.h"

@implementation JZBBudgetItems
@dynamic budget_item_id;
@dynamic budget_id;
@dynamic catalog_id;
@dynamic amount;
@dynamic desc;

//provide all keys for properties
-(NSArray*)allKeysForValues{
    NSArray* keys = [NSArray arrayWithObjects:@"budget_item_id", @"budget_id", @"catalog_id", @"amount", @"desc", nil];
    
    return keys;
}

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
        //catelog_id is an exception. It's a typo in remote DB
        if ([column isEqualToString:@"catelog_id"]){
            column = @"catalog_id";
        }else if([column isEqualToString:@"description"]){
            column = @"desc";
        }else if ([column isEqualToString:@"amount"]){
            type = JZBDataTypeDouble;
        }
        [self setValue:value forKey:column type:type];
        
    }
    
    return YES;
}

-(id)init{
    if (self = [super init]){
        if (!self.budget_item_id){
            self.budget_item_id = [self stringForObjectID];
        }
    }
    
    return self;
}

@end
