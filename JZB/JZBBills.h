//
//  JZBBills.h
//  JZB
//
//  Created by Jin Jin on 11-7-9.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "JZBManagedObject.h"

#define BILL_TYPE_EXPEND    @"expense"
#define BILL_TYPE_INCOME    @"income"
#define BILL_TYPE_TRANSFER  @"transfer"
#define BILL_TYPE_LEND      @"lend"
#define BILL_TYPE_BORROW    @"borrow"
#define BILL_TYPE_REPAYOUT  @"repayout"
#define BILL_TYPE_REPAYIN   @"repayin"

typedef enum{
    JZBBillsTypeExpend,
    JZBBillsTypeIncome,
    JZBBillsTypeTransfer,
    JZBBillsTypeLend,
    JZBBillsTypeBorrow,
    JZBBillsTypeRepayOut,
    JZBBillsTypeRepayIn
} JZBBillsType;

@class JZBAccounts, JZBBorrowers, JZBCatalogs, JZBSubCatalogs;

@interface JZBBills : JZBManagedObject {
@private
}
@property (nonatomic, retain) NSString * to_account_id;
@property (nonatomic, retain) NSDate * version;
@property (nonatomic, retain) NSNumber * amount;
@property (nonatomic, retain) NSString * bill_id;
@property (nonatomic, retain) NSString * sub_catalog_id;
@property (nonatomic, retain) NSString * borrower_id;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * catalog_id;
@property (nonatomic, retain) NSNumber * month;
@property (nonatomic, retain) NSString * kind;
@property (nonatomic, retain) NSString * account_id;

@end
