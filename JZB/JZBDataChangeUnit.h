//
//  JZBDataChange.h
//  JZB
//
//  Created by Jin Jin on 11-4-1.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JZBManagedObject.h"

typedef enum{
    JZBDataChangeTypeLocalSync,
    JZBDataChangeTypeLocalDelete,
    JZBDataChangeTypeRemoteSync,
    JZBDataChangeTypeRemoteDelete,
} JZBDataChangeType;

@interface JZBDataChangeUnit : NSObject {
    JZBDataChangeType _type;
    NSString* _tableName;
    NSString* _primaryKey;
    NSMutableArray* _columns;
    NSMutableArray* _data;
    
}

@property (nonatomic, assign) JZBDataChangeType type;
@property (nonatomic, retain) NSString* tableName;
@property (nonatomic, retain) NSString* primaryKey;
@property (nonatomic, retain) NSMutableArray* columns;
@property (nonatomic, retain) NSMutableArray* data;

-(id)initWithJSONMessage:(NSString*)msg type:(JZBDataChangeType)type;
-(id)initWithJSONObj:(NSObject*)JSONObj type:(JZBDataChangeType)type;
-(id)initWithJZBManagedObject:(JZBManagedObject*)jzbObj;
+(id)dataChangeUnitWithJZBManagedObject:(JZBManagedObject*)jzbObj;
-(NSString*)JSON;

-(void)mergeChangeData:(JZBDataChangeUnit*)newUnit;

@end

@interface JZBDataChangeUnit (private)

-(NSString*)JSONForArray:(NSArray*)array;
-(NSString*)JSONForString:(NSString*)string;
    
@end
