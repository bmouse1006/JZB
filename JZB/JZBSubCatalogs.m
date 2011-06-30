//
//  JZBSubCatalogs.m
//  JZB
//
//  Created by Jin Jin on 11-6-27.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "JZBSubCatalogs.h"


@implementation JZBSubCatalogs
@dynamic sort;
@dynamic catalog_id;
@dynamic kind;
@dynamic name;
@dynamic version;
@dynamic parent_id;

//provide all keys for properties
-(NSArray*)allKeysForValues{
    NSArray* keys = [NSArray arrayWithObjects:@"sort", @"catalog_id", @"kind", @"name", @"version", @"parent_id", nil];
    
    return keys;
}
    
-(id)getKeyValue{
    return self.catalog_id;
}

-(BOOL)isEqualToManagedObject:(JZBManagedObject*)object{
    BOOL result = NO;
    if ([object isKindOfClass:[JZBSubCatalogs class]]){
        JZBSubCatalogs* target = (JZBSubCatalogs*)object;
        if (target != nil){
            if (self.catalog_id != nil && target.catalog_id != nil){
                result = [self.catalog_id isEqualToString:target.catalog_id];
            }
        }
    }
    
    return result;
}

-(void)setupDefaultValues{
    self.catalog_id = [self stringForObjectID];
    self.kind = CATALOG_KIND_INCOME;
    self.version = [NSDate date];;
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
        //catelog_id is an exception. It's a typo in remote DB
        if ([column isEqualToString:@"catelog_id"]){
            column = @"catalog_id";
        }else if ([column isEqualToString:@"sort"]){
            type = JZBDataTypeInt;
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
        if (!self.catalog_id){
            self.catalog_id = [self stringForObjectID];
        }
    }
    
    return self;
}


@end
