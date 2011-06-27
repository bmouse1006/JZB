//
//  JZBAccounts.h
//  JZB
//
//  Created by Jin Jin on 11-4-5.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JZBManagedObject.h"

#define ACCOUNT_KIND_CASH       @"cash"
#define ACCOUNT_KIND_CREDITCARD @"creditcard"
#define ACCOUNT_KIND_BANKCARD   @"bankcard"
#define ACCOUNT_KIND_STOCK      @"stock"
#define ACCOUNT_KIND_FUND       @"fund"
#define ACCOUNT_KIND_OTHER      @"other" 

@interface JZBAccounts : JZBManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * amount;
@property (nonatomic, retain) NSNumber * sort;
@property (nonatomic, retain) NSString * account_id;
@property (nonatomic, retain) NSDate * version;
@property (nonatomic, retain) NSString * kind;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * desc;

+(NSArray*)objectsForName:(NSString*)name;

@end
