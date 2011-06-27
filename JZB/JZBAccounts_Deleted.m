//
//  JZBAccounts_Deleted.m
//  JZB
//
//  Created by Jin Jin on 11-6-27.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "JZBAccounts_Deleted.h"


@implementation JZBAccounts_Deleted
@dynamic sort;
@dynamic amount;
@dynamic account_id;
@dynamic desc;
@dynamic kind;
@dynamic name;
@dynamic version;

-(id)getKeyValue{
    return self.account_id;
}

@end
