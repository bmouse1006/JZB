//
//  JZBManagedObject.h
//  JZB
//
//  Created by Jin Jin on 11-4-5.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

typedef enum{
    JZBDataTypeInt,
    JZBDataTypeLong,
    JZBDataTypeString,
    JZBDataTypeDouble,
    JZBDataTypeDate
} JZBDataType;

@interface JZBManagedObject : NSManagedObject {

}
//get ID string for the object ID
-(NSString*)stringForObjectID;
-(BOOL)setValues:(NSArray*)values forColumns:(NSArray*)columns;
//convert data type from NSString to varis types
//all values in JSON is string
-(void)setValue:(NSString*)value forKey:(NSString *)key type:(JZBDataType)type;
//save all the change to DB
-(void)persistantChange;
//setup default values for properties
-(void)setupDefaultValues;
//check if two managed objects are the same one
-(BOOL)isEqualToManagedObject:(JZBManagedObject*)obj;
//get primary key for the table
-(NSString*)primaryKey;
//get table name for this model
-(NSString*)tableName;
//get names for columns
-(NSArray*)columns;
//get data for columns
-(NSArray*)data;

+(NSArray*)allManagedObjects;
+(NSArray*)allManagedObjectsWithcontext:(NSManagedObjectContext*)context;
+(NSArray*)objectsForKey:(NSString*)key andValue:(NSString*)value;
+(NSArray*)objectsForKey:(NSString*)key andValue:(NSString*)value context:(NSManagedObjectContext*)context;
//create a new object using current class name as model name
+(id)insertNewManagedObject;
//return model name for current model
+(NSString*)modelName;

@end
