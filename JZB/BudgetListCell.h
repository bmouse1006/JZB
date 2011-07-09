//
//  BudgetListCell.h
//  JZB
//
//  Created by Jin Jin on 11-7-9.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JZBBudgets.h"

@interface BudgetListCell : UITableViewCell{
    JZBBudgets* _budget;
    
    UILabel* _startLabel;
    UILabel* _endLabel;
    UILabel* _planExpLabel;
    UILabel* _planIncomeLabel;
    UILabel* _actualExpLabel;
    UILabel* _actualIncomeLabel;
    
}

@property (nonatomic, retain, setter = setBudget:) JZBBudgets* budget;

@property (nonatomic, retain) IBOutlet UILabel* startLabel;
@property (nonatomic, retain) IBOutlet UILabel* endLabel;
@property (nonatomic, retain) IBOutlet UILabel* planExpLabel;
@property (nonatomic, retain) IBOutlet UILabel* planIncomeLabel;
@property (nonatomic, retain) IBOutlet UILabel* actualExpLabel;
@property (nonatomic, retain) IBOutlet UILabel* actualIncomeLabel;

@end
