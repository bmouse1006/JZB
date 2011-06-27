//
//  JZBSubCatalogs.h
//  JZB
//
//  Created by Jin Jin on 11-6-27.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JZBManagedObject.h"


@interface JZBSubCatalogs : JZBManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * sort;
@property (nonatomic, retain) NSString * catalog_id;
@property (nonatomic, retain) NSString * kind;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * version;
@property (nonatomic, retain) NSString * parent_id;

@end
