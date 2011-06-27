//
//  JZBBorrowers.m
//  JZB
//
//  Created by Jin Jin on 11-4-5.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "JZBBorrowers.h"

@implementation JZBBorrowers
@dynamic borrower_id;
@dynamic kind;
@dynamic name;
@dynamic sort;
@dynamic version;

-(id)getKeyValue{
    return self.borrower_id;
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
        if ([column isEqualToString:@"sort"]){
            type = JZBDataTypeInt;
        }else if([column isEqualToString:@"version"]){
            type = JZBDataTypeDate;
        }
        [self setValue:value forKey:column type:type];
        
    }
    
    return YES;
}

-(id)init{
    self = [super init];
    if (self){
        if (!self.borrower_id){
            self.borrower_id = [self stringForObjectID];
        }
    }
    
    return self;
}

@end
