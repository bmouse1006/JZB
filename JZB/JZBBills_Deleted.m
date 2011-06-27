//
//  JZBBills_Deleted.m
//  JZB
//
//  Created by Jin Jin on 11-6-27.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "JZBBills_Deleted.h"


@implementation JZBBills_Deleted
@dynamic month;
@dynamic amount;
@dynamic account_id;
@dynamic bill_id;
@dynamic borrower_id;
@dynamic catalog_id;
@dynamic desc;
@dynamic kind;
@dynamic sub_catalog_id;
@dynamic title;
@dynamic to_account_id;
@dynamic date;
@dynamic version;

-(id)getKeyValue{
    return self.bill_id;
}

@end
