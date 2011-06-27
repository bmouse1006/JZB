//
//  JZBBudgets_Deleted.m
//  JZB
//
//  Created by Jin Jin on 11-6-27.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "JZBBudgets_Deleted.h"


@implementation JZBBudgets_Deleted
@dynamic budget_id;
@dynamic desc;
@dynamic end_date;
@dynamic start_date;

-(id)getKeyValue{
    return self.budget_id;
}

@end
