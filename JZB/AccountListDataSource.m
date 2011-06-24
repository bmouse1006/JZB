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
@synthesize account = _account;

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    NSInteger number = [[self.fetchedController sections] count];
    number = (!number)?1:number;
    DebugLog(@"number of section is %d", number);
    return number;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedController sections] objectAtIndex:section];
    NSInteger number = [sectionInfo numberOfObjects];
    number = (![[self.fetchedController fetchedObjects] count])?1:number;
    DebugLog(@"number of rows in section %d is %d", section, number);
    return number;
}

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
        self.modelName = @"JZBAccounts";
    }
    
    return self;
}

-(void)dealloc{
    self.account = nil;
    [super dealloc];
}

@end
