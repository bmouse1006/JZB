//
//  JZBBudgets_Deleted.h
//  JZB
//
//  Created by Jin Jin on 11-6-27.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JZBManagedObject.h"

@interface JZBBudgets_Deleted : JZBManagedObject {
@private
}
@property (nonatomic, retain) NSString * budget_id;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSDate * end_date;
@property (nonatomic, retain) NSDate * start_date;

@end
