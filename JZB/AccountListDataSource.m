//
//  AccountListDataSource.m
//  JZB
//
//  Created by Jin Jin on 11-4-20.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "AccountListDataSource.h"

@implementation AccountListDataSource

@synthesize tempCell = _tempCell;

#pragma mark - override methods

-(NSString*)getModelName{
    return @"JZBAccounts";
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AccountListCell";
    AccountListCell* cell = (AccountListCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell){
        [[NSBundle mainBundle] loadNibNamed:@"AccountListCell" owner:self options:nil];
        cell = self.tempCell;
        self.tempCell = nil;
    }
    
    //if we have account, rather then zero
    if ([[self.fetchedController fetchedObjects] count]){
        NSManagedObject* obj = [self.fetchedController objectAtIndexPath:indexPath];
        // Configure the cell...
        cell.account = (JZBAccounts*)obj;        
        //if the obj is the selected one, check mark the cell
        if ([self.managedObj isEqualToManagedObject:cell.account]){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }else{
        //no accounts in DB
        cell.textLabel.text = @"no account";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

-(id)init{
    self = [super init];
    if (self){
//        self.modelName = @"JZBAccounts";
    }
    
    return self;
}

-(void)dealloc{
    self.tempCell = nil;
    [super dealloc];
}

@end
