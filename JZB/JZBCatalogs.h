//
//  JZBCatalogs.h
//  JZB
//
//  Created by Jin Jin on 11-4-5.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JZBManagedObject.h"

#define CATALOG_KIND_INCOME @"income"
#define CATALOG_KIND_EXPEND @"expend"

@interface JZBCatalogs : JZBManagedObject {
@private
}
@property (nonatomic, retain) NSString * catalog_id;
@property (nonatomic, retain) NSString * kind;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * sort;
@property (nonatomic, retain) NSDate * version;

+(NSArray*)objectsForName:(NSString*)name context:(NSManagedObjectContext*)context;
+(NSArray*)catalogsForKind:(NSString*)kind context:(NSManagedObjectContext*)context;
-(BOOL)setValues:(NSArray*)values forColumns:(NSArray*)columns;

@end
