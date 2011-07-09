//
//  BudgetListDataSource.h
//  JZB
//
//  Created by Jin Jin on 11-7-9.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "JZBDataSource.h"
#import "BudgetListCell.h"

@interface BudgetListDataSource : JZBDataSource{
    BudgetListCell* _tempCell;
}

@property (nonatomic, retain) IBOutlet BudgetListCell* tempCell;

@end
