//
//  JZBBudgetItems_Deleted.m
//  JZB
//
//  Created by Jin Jin on 11-6-27.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "JZBBudgetItems_Deleted.h"


@implementation JZBBudgetItems_Deleted
@dynamic amount;
@dynamic budget_id;
@dynamic budget_item_id;
@dynamic catalog_id;
@dynamic desc;

-(id)getKeyValue{
    return self.budget_id;
}

@end
