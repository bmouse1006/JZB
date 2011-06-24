//
//  BillListViewController.m
//  JZB
//
//  Created by Jin Jin on 11-4-15.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "BillListViewController.h"
#import "BillListDataSource.h"
#import "BillEditViewController.h"

@implementation BillListViewController

@synthesize filterSeg = _filterSeg;
@synthesize theTableView = _theTableView;
@synthesize mySearchBar = _mySearchBar;
@synthesize mySearchDisplayController = _mySearchDisplayController;
@synthesize dataSource = _dataSource;
@synthesize account = _account;

#pragma mark - getter and setter
-(JZBDataSource*)getDataSource{
    if (!_dataSource){
        _dataSource = [[BillListDataSource alloc] init];
    }
    
    return _dataSource;
}

-(void)setAccount:(JZBAccounts *)account{
    if (_account != account){
        [_account release];
        _account = account;
        [_account retain];
        self.dataSource.managedObj = _account;
    }
}

-(IBAction)filterSegIsClicked:(id)sender{
    DebugLog(@"filter seg is clicked", nil);
}

-(void)refreshList{
    [self.dataSource refresh];
    [self.theTableView reloadData];
}

-(void)releaseRetainedObjects{
    self.filterSeg = nil;
    self.theTableView = nil;
    self.mySearchBar = nil;
    self.mySearchDisplayController = nil;
    self.dataSource = nil;
}

- (void)dealloc
{
    [self releaseRetainedObjects];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
//    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.filterSeg];
//    self.navigationItem.rightBarButtonItem = rightItem;
    self.theTableView.dataSource = self.dataSource;
    [self refreshList];
    self.title = self.account.name;
//    [rightItem release];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //show bill edit view with detail of bill
    BillEditViewController* billEditor = [[BillEditViewController alloc] init];
    billEditor.bill = [self.dataSource objAtIndexPath:indexPath];
    [self.navigationController pushViewController:billEditor animated:YES];
    [billEditor release];
    //
    [tableView deselectRowAtIndexPath:indexPath 
                             animated:YES];
}

@end
