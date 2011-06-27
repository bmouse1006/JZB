//
//  JZBBorrowers_Deleted.m
//  JZB
//
//  Created by Jin Jin on 11-6-27.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "JZBBorrowers_Deleted.h"


@implementation JZBBorrowers_Deleted
@dynamic sort;
@dynamic borrower_id;
@dynamic kind;
@dynamic name;
@dynamic version;

-(id)getKeyValue{
    return self.borrower_id;
}

@end
