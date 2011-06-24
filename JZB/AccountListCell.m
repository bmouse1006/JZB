//
//  AccountListCell.m
//  JZB
//
//  Created by Jin Jin on 11-4-15.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "AccountListCell.h"


@implementation AccountListCell

@synthesize account = _account;

-(void)setJZBAccount:(JZBAccounts*)acc{
    if (_account != acc){
        [_account release];
        _account = acc;
        [_account retain];
        self.textLabel.text = acc.name;
    }
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
    [super dealloc];
}

@end
