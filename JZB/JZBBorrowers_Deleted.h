//
//  JZBBorrowers_Deleted.h
//  JZB
//
//  Created by Jin Jin on 11-6-27.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JZBManagedObject.h"

@interface JZBBorrowers_Deleted : JZBManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * sort;
@property (nonatomic, retain) NSString * borrower_id;
@property (nonatomic, retain) NSString * kind;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * version;

@end
