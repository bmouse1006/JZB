//
//  JZBCatalogs.m
//  JZB
//
//  Created by Jin Jin on 11-4-5.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "JZBCatalogs.h"
#import "JJObjectManager.h"

@implementation JZBCatalogs
@dynamic catalog_id;
@dynamic kind;
@dynamic name;
@dynamic sort;
@dynamic version;

+(NSArray*)objectsForName:(NSString*)name context:(NSManagedObjectContext*)context{
    return [self objectsForKey:@"name" andValue:name context:context];
}

+(NSArray*)catalogsForKind:(NSString*)kind context:(NSManagedObjectContext*)context{
    return [self objectsForKey:@"kind" andValue:kind context:context];
}
//check if two catalog are the same
-(BOOL)isEqualToManagedObject:(JZBManagedObject*)object{
    JZBCatalogs* target = (JZBCatalogs*)object;
    BOOL result = NO;
    if (target != nil){
        if (self.catalog_id != nil && target.catalog_id != nil){
            result = [self.catalog_id isEqualToString:target.catalog_id];
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
    if (self = [super init]){
        if (!self.catalog_id){
            self.catalog_id = [self stringForObjectID];
        }
    }
    
    return self;
}


@end
