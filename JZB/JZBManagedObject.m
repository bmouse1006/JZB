//
//  JZBManagedObject.m
//  JZB
//
//  Created by Jin Jin on 11-4-5.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "JZBManagedObject.h"
#import "JJObjectManager.h"
#import "JZBSynchronizer.h"
#include <objc/runtime.h>

@implementation JZBManagedObject

#pragma mark - Class methods

+(NSArray*)allManagedObjectsWithcontext:(NSManagedObjectContext*)context{
    NSString* modelName = [self modelName];
    NSArray* objs = nil;
    if (modelName){
        objs = [JJObjectManager objectsByModelName:modelName context:context];
    }
    
    return objs;
}

+(NSArray*)allManagedObjects{
    return [self allManagedObjectsWithcontext:nil];
}
//
//return all object with the given key and value. Model name it the class name
//
+(NSArray*)objectsForKey:(NSString*)key andValue:(NSString*)value context:(NSManagedObjectContext*)context{
    NSArray* result = nil;
    NSString* modelName = [self modelName];
    DebugLog(@"searching for %@", modelName);
    DebugLog(@"key is %@, value is %@", key, value);
    if (modelName){
        result = [JJObjectManager objectsByModelName:modelName 
                                             withKey:key 
                                            andValue:value 
                                             context:context];
    }
    
    return result;
}
+(NSArray*)objectsForKey:(NSString*)key andValue:(NSString*)value{
    return [self objectsForKey:key
                      andValue:value 
                       context:nil];
}

+(id)insertNewManagedObject{
    NSString* modelName = [self modelName];
    id newObj = nil;
    if (modelName){
        newObj = [JJObjectManager newManagedObjectWithModelName:modelName];
    }
    
    return newObj;
}

+(NSString*)modelName{
    //get model name for current class
    //class name is the model name
    NSString* modelName = [NSString stringWithCString:(const char*)class_getName([self class]) 
                                             encoding:NSUTF8StringEncoding];
    
    return modelName;
}

#pragma mark - instance methods
-(BOOL)isEqualToManagedObject:(JZBManagedObject*)obj{
    return YES;
}

-(NSString*)stringForObjectID{
    NSManagedObjectID* objID = [self objectID];
    NSURL* URL = [objID URIRepresentation];
    return [URL absoluteString];
}

-(void)setValue:(NSString*)value forKey:(NSString *)key type:(JZBDataType)type{
    NSDateFormatter* formatter = nil;
    id val = nil;
    switch (type) {
        case JZBDataTypeInt:
            val = [NSNumber numberWithInt:[value intValue]];
            break;
        case JZBDataTypeLong:
            val = [NSNumber numberWithLong:[value longLongValue]];
            break;
        case JZBDataTypeString:
            val = value;
            break;
        case JZBDataTypeDate:
            formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
            [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
            val = [formatter dateFromString:value];
            break;
        case JZBDataTypeDouble:
            val = [NSNumber numberWithDouble:[value doubleValue]];
            break;
        default:
            break;
    }
    
    [self setValue:val forKey:key];
                   
    [formatter release];
}

-(BOOL)setValues:(NSArray*)values forColumns:(NSArray*)columns{
    return YES;
}

-(void)persistantChange{
    [JJObjectManager commitChangeForContext:[self managedObjectContext]];
    //if no exception is thrown
    //put this change to locale change queue
    [JZBSynchronizer addLocalChange:[JZBDataChangeUnit dataChangeUnitWithJZBManagedObject:self]];
}

-(void)dealloc{
    [super dealloc];
}

-(void)setupDefaultValues{
    //do nothing
}
//get primary key for the table
-(NSString*)primaryKey{
    
    NSString* pathPK = [[NSBundle mainBundle] pathForResource:BUNDLENAME_PKFORTABLES ofType:@"plist"];
    NSDictionary* pkBundle = [NSDictionary dictionaryWithContentsOfFile:pathPK];
    return [pkBundle valueForKey:[self tableName]];
}
//get table name for this model
-(NSString*)tableName{
    NSString* pathModelName = [[NSBundle mainBundle] pathForResource:BUNDLENAME_MODELNAMEFORTABLES 
                                                              ofType:@"plist"];
    NSDictionary* modelNameBundle = [NSDictionary dictionaryWithContentsOfFile:pathModelName];

    return [modelNameBundle valueForKey:[[self class] modelName]];
}
//get names for columns
-(NSArray*)columns{
    //nothing here
    return nil;
}
//get data for columns
-(NSArray*)data{
    //nothing here
    return nil;
}

@end
