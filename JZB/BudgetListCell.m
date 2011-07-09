//
//  BudgetListCell.m
//  JZB
//
//  Created by Jin Jin on 11-7-9.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "BudgetListCell.h"

@implementation BudgetListCell

@synthesize budget = _budget;

@synthesize startLabel = _startLabel;
@synthesize endLabel = _endLabel;
@synthesize planExpLabel = _planExpLabel;
@synthesize planIncomeLabel = _planIncomeLabel;
@synthesize actualExpLabel = _actualExpLabel;
@synthesize actualIncomeLabel = _actualIncomeLabel;

-(void)setBudget:(JZBBudgets*)budget{
    if (_budget != budget){
        [_budget release];
        _budget = budget;
        [_budget retain];
        //do more
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

-(void)dealloc{
    self.startLabel = nil;
    self.endLabel = nil;
    self.planIncomeLabel = nil;
    self.planExpLabel = nil;
    self.actualIncomeLabel = nil;
    self.actualExpLabel = nil;
    [super dealloc];
}

@end
