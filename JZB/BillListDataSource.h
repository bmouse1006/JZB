//
//  BillListDataSource.h
//  JZB
//
//  Created by Jin Jin on 11-5-5.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "JZBDataSource.h"
#import "BillListCell.h"

@interface BillListDataSource : JZBDataSource {
    BillListCell* _tempCell;
    
    NSString* _accountID;
}

@property (nonatomic, retain) IBOutlet BillListCell* tempCell;
@property (nonatomic, retain, setter = setAccountID:) NSString* accountID;

@end
