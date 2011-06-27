//
//  JZBCatalogs_Deleted.m
//  JZB
//
//  Created by Jin Jin on 11-6-27.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "JZBCatalogs_Deleted.h"


@implementation JZBCatalogs_Deleted
@dynamic sort;
@dynamic catalog_id;
@dynamic kind;
@dynamic name;
@dynamic version;

-(id)getKeyValue{
    return self.catalog_id;
}

@end
