//
//  BillListCell.h
//  JZB
//
//  Created by Jin Jin on 11-6-24.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JZBBills.h"

@interface BillListCell : UITableViewCell {
    JZBBills* _bill;
}

@property (nonatomic, retain, setter = setBill:) JZBBills* bill;

-(void)assemblyCellForCurrentBill;

@end
