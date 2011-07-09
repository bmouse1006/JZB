//
//  BillListCell.m
//  JZB
//
//  Created by Jin Jin on 11-6-24.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "BillListCell.h"
#import "JZBAccounts.h"
#import "JZBCatalogs.h"

@implementation BillListCell

@synthesize bill = _bill;
@synthesize nameLabel = _nameLabel;
@synthesize catalogLabel = _catalogLabel;
@synthesize amountLabel = _amountLabel;

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
//    JZBAccounts* account = [JZBAccounts objectForID:self.bill.account_id];
//    JZBAccounts* toAccount = [JZBAccounts objectForID:self.bill.to_account_id];
    JZBAccounts* catalog = (self.bill == nil)?nil:[JZBCatalogs objectForID:self.bill.catalog_id];
    //set name presentation for bill
    self.nameLabel.text = self.bill.title;
    //set catalog name presentation for bill
    self.catalogLabel.text = catalog.name;
    //set amount presentation for bill
    self.amountLabel.text = [self.bill.amount stringValue];
    //change background color according to bill type income/outcome/other
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
    self.nameLabel = nil;
    self.catalogLabel = nil;
    self.amountLabel = nil;
    [super dealloc];
}

@end
