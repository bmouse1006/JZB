//
//  JZBBudgetItems_Deleted.h
//  JZB
//
//  Created by Jin Jin on 11-6-27.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JZBManagedObject.h"

@interface JZBBudgetItems_Deleted : JZBManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * amount;
@property (nonatomic, retain) NSString * budget_id;
@property (nonatomic, retain) NSString * budget_item_id;
@property (nonatomic, retain) NSString * catalog_id;
@property (nonatomic, retain) NSString * desc;

@end
