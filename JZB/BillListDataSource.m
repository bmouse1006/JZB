//
//  BillListDataSource.m
//  JZB
//
//  Created by Jin Jin on 11-5-5.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "BillListDataSource.h"


@implementation BillListDataSource

@synthesize tempCell = _tempCell;
@synthesize accountID = _accountID;

#pragma mark - setter and getter

-(void)setManagedObj:(JZBManagedObject *)managedObj{
    if (_managedObj != managedObj){
        [_managedObj release];
        _managedObj = managedObj;
        [_managedObj retain];
        
        self.accountID = [_managedObj valueForKey:@"account_id"];
        
    }
}

-(void)setAccountID:(NSString *)accID{
    if (_accountID != accID){
        [_accountID release];
        _accountID = accID;
        [_accountID retain];
        
        //generate a new predicate for fetcher
        if (_accountID != nil){
            self.predicate = [NSPredicate predicateWithFormat:@"%K like %@", @"account_id",_accountID];
        }else{
            self.predicate = nil;
        }
    }
}

#pragma mark - overrided methods
-(NSString*)getModelName{
    return @"JZBBills";
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BillListCell";
    BillListCell* cell = (BillListCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell){
        [[NSBundle mainBundle] loadNibNamed:@"BillListCell" owner:self options:nil];
        cell = self.tempCell;
        self.tempCell = nil;
    }
    
    //if we have account, rather then zero
    if ([[self.fetchedController fetchedObjects] count]){
        NSManagedObject* obj = [self.fetchedController objectAtIndexPath:indexPath];
        // Configure the cell...
        cell.bill = (JZBBills*)obj;        
    }else{
        //no accounts in DB
        cell.textLabel.text = @"no bill";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

#pragma mark - init and dealloc
-(void)dealloc{
    self.tempCell = nil;
    self.accountID = nil;
    [super dealloc];
}

@end
