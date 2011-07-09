//
//  JZBDataChange.m
//  JZB
//
//  Created by Jin Jin on 11-4-1.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "JZBDataChangeUnit.h"
#import "JSON.h"

#define JSONPROPERTYNAME_TABLENAME  @"TableName"
#define JSONPROPERTYNAME_PRIMARYKEY @"PrimaryKey"
#define JSONPROPERTYNAME_COLUMNS    @"Columns"
#define JSONPROPERTYNAME_DATA       @"Data"

#define JSONTEMPLATE_JZBDATACHANGEUNIT @"{\"Columns\":[%@],\"Data\":[%@],\"TableName\":\"%@\",\"PrimaryKey\":\"%@\"}"

@implementation JZBDataChangeUnit

@synthesize type = _type;
@synthesize tableName = _tableName;
@synthesize primaryKey = _primaryKey;
@synthesize columns = _columns;
@synthesize data = _data;

-(id)initWithJSONMessage:(NSString*)msg type:(JZBDataChangeType)type;{
    self = [super init];
    if (self){
        NSDictionary* JSONObj = [msg JSONValue];
        [self initWithJSONObj:JSONObj type:type];
    }
    
    return self;
}

-(id)initWithJSONObj:(NSObject*)JSONObj type:(JZBDataChangeType)type{
    self = [super init];
    if (self){
        self.tableName = [JSONObj valueForKey:JSONPROPERTYNAME_TABLENAME];
        self.primaryKey = [JSONObj valueForKey:JSONPROPERTYNAME_PRIMARYKEY];
        NSArray* mColumns = [JSONObj valueForKey:JSONPROPERTYNAME_COLUMNS];
//        self.columns = [NSMutableArray arrayWithCapacity:0];
//        [self.columns addObjectsFromArray:mColumns];
        self.columns = [NSMutableArray arrayWithArray:mColumns];
        NSArray* mData = [JSONObj valueForKey:JSONPROPERTYNAME_DATA];
//        self.data = [NSMutableArray arrayWithCapacity:0];
//        [self.data addObjectsFromArray:mData];
        self.data = [NSMutableArray arrayWithArray:mData];
        self.type = type;
    }
    
    return self;
}

-(id)initWithJZBManagedObject:(JZBManagedObject*)jzbObj{
    self = [super init];
    if (self){
        self.tableName = [[jzbObj class] tableName];
        self.primaryKey = [[jzbObj class] primaryKey];
        self.columns = [NSMutableArray arrayWithArray:[jzbObj columns]];
        self.data = [NSMutableArray arrayWithArray:[jzbObj data]];
        
        self.type = JZBDataChangeTypeLocalSync;
    }
    
    return self;
}

+(id)dataChangeUnitWithJZBManagedObject:(JZBManagedObject*)jzbObj{
    JZBDataChangeUnit* obj = [[[JZBDataChangeUnit alloc] initWithJZBManagedObject:jzbObj] autorelease];
    return obj;
}

-(NSString*)JSON{
    NSMutableString* columnString = [NSMutableString stringWithCapacity:0];
    NSMutableString* dataString = [NSMutableString stringWithCapacity:0];
    
    int flag = 0;
    for (NSString* columnName in self.columns){
        if (flag){
            [columnString appendString:@","];
        }
        
        [columnString appendFormat:@"%@", [self JSONForString:columnName]];
        
        flag = 1;
    }
    
    flag = 0;
    
    for (NSArray* data in self.data){
        if (flag){
            [dataString appendString:@","];
        }
        
        [columnString appendFormat:@"%@", [self JSONForArray:data]];
        
        flag = 1;
    }
    
    return [NSString stringWithFormat:JSONTEMPLATE_JZBDATACHANGEUNIT, columnString, dataString, self.tableName, self.primaryKey];
}
         
-(void)mergeChangeData:(JZBDataChangeUnit*)newUnit{
    [self.data addObjectsFromArray:[newUnit data]];
}

-(void)dealloc{
    [self.tableName release];
    [self.primaryKey release];
    [self.columns release];
    [self.data release];
    [super dealloc];
}

-(NSDictionary*)propertyList{
    NSMutableDictionary* propertyList = [NSMutableDictionary dictionaryWithCapacity:0];
    [propertyList setObject:self.tableName forKey:JSONPROPERTYNAME_TABLENAME];
    [propertyList setObject:self.primaryKey forKey:JSONPROPERTYNAME_PRIMARYKEY];
    [propertyList setObject:self.columns forKey:JSONPROPERTYNAME_COLUMNS];
    [propertyList setObject:self.data forKey:JSONPROPERTYNAME_DATA];
    return propertyList;
}

+(JZBDataChangeUnit*)unitFromPropertyList:(NSDictionary*)propertyList{
    JZBDataChangeUnit* unit = [[JZBDataChangeUnit alloc] init];
    unit.tableName = [propertyList valueForKey:JSONPROPERTYNAME_TABLENAME];
    unit.primaryKey = [propertyList valueForKey:JSONPROPERTYNAME_PRIMARYKEY];
    unit.columns = [propertyList valueForKey:JSONPROPERTYNAME_COLUMNS];
    unit.data = [propertyList valueForKey:JSONPROPERTYNAME_DATA];
    
    return [unit autorelease];
}

@end

@implementation JZBDataChangeUnit (private)

-(NSString*)JSONForArray:(NSArray*)array{
    NSMutableString* string = [NSMutableString stringWithCapacity:0];
    
    [string appendString:@"["];
    
    int flag = 0;
    
    for (NSString* str in array){
        if (flag){
            [string appendString:@","];
        }
        
        [string appendFormat:@"%@", [self JSONForString:str]];
        
        flag = 1;
    }
    
    [string appendString:@"]"];
    return string;
}

-(NSString*)JSONForString:(NSString*)string{
    return [NSString stringWithFormat:@"\"%@\"", string];
}

@end
