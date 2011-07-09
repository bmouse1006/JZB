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
    
    UILabel* _nameLabel;
    UILabel* _catalogLabel;
    UILabel* _amountLabel;
    
}

@property (nonatomic, retain, setter = setBill:) JZBBills* bill;
@property (nonatomic, retain) IBOutlet UILabel* nameLabel;
@property (nonatomic, retain) IBOutlet UILabel* catalogLabel;
@property (nonatomic, retain) IBOutlet UILabel* amountLabel;

-(void)assemblyCellForCurrentBill;

@end
