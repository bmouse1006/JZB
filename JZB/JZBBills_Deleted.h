//
//  JZBBills_Deleted.h
//  JZB
//
//  Created by Jin Jin on 11-6-27.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JZBManagedObject.h"

@interface JZBBills_Deleted : JZBManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * month;
@property (nonatomic, retain) NSNumber * amount;
@property (nonatomic, retain) NSString * account_id;
@property (nonatomic, retain) NSString * bill_id;
@property (nonatomic, retain) NSString * borrower_id;
@property (nonatomic, retain) NSString * catalog_id;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSString * kind;
@property (nonatomic, retain) NSString * sub_catalog_id;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * to_account_id;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSDate * version;

@end
