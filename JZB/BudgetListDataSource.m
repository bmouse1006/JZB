//
//  BudgetListDataSource.m
//  JZB
//
//  Created by Jin Jin on 11-7-9.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "BudgetListDataSource.h"

@implementation BudgetListDataSource

@synthesize tempCell = _tempCell;

-(NSString*)getModelName{
    return @"JZBBudgets";
}

-(NSArray*)getSortDescriptors{
    //sorted by date, descending
    if (!_sortDescriptors){
        NSSortDescriptor* sortDesc = [NSSortDescriptor sortDescriptorWithKey:@"start_date" ascending:NO];
        _sortDescriptors = [NSArray arrayWithObject:sortDesc];
        [_sortDescriptors retain];
    }
    
    return _sortDescriptors;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BudgetListCell";
    BudgetListCell* cell = (BudgetListCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell){
        [[NSBundle mainBundle] loadNibNamed:@"BudgetListCell" owner:self options:nil];
        cell = self.tempCell;
        self.tempCell = nil;
    }
    
    //if we have account, rather then zero
    if ([[self.fetchedController fetchedObjects] count]){
        NSManagedObject* obj = [self.fetchedController objectAtIndexPath:indexPath];
        // Configure the cell...
        cell.budget = (JZBBudgets*)obj;        
    }else{
        //no accounts in DB
        cell.textLabel.text = @"no bill";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

-(void)dealloc{
    self.tempCell = nil;
    [super dealloc];
}

@end
