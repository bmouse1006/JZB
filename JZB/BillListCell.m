//
//  BillListCell.m
//  JZB
//
//  Created by Jin Jin on 11-6-24.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "BillListCell.h"

@implementation BillListCell

@synthesize bill = _bill;

-(void)setBill:(JZBBills *)mBill{
    if (_bill != mBill){
        [_bill release];
        _bill = mBill;
        [_bill retain];
        [self assemblyCellForCurrentBill];
    }
}

-(void)assemblyCellForCurrentBill{
    //just for test
    //would be add more code to make it beauty
    
    self.textLabel.text = _bill.bill_id;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    self.bill = nil;
    [super dealloc];
}

@end
