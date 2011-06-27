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
@synthesize addItem = _addItem;
@synthesize editItem = _editItem;
@synthesize doneItem = _doneItem;
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

-(IBAction)editItemIsClicked:(id)sender{
    self.navigationItem.rightBarButtonItem = self.doneItem;
    [self.theTableView setEditing:YES animated:YES];
}

-(IBAction)doneItemIsClicked:(id)sender{
    self.navigationItem.rightBarButtonItem = self.editItem;
    [self.theTableView setEditing:NO animated:YES];
}

-(IBAction)addItemIsClicked:(id)sender{
     BillListViewController* controller= [[BillEditViewController alloc] initWithNibName:@"BillEditViewController" bundle:nil];

    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:controller];

//    [[UIApplication sharedApplication].keyWindow.rootViewController presentModalViewController:nav animated:YES];
    [self presentModalViewController:nav animated:YES];

    [nav release];
    [controller release];
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
//    [rightItem release];
    self.theTableView.dataSource = self.dataSource;
    self.title = self.account.name;
    self.navigationItem.rightBarButtonItem = self.editItem;
    [self setToolbarItems:[NSArray arrayWithObject:self.addItem]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refreshList];
    //show tool bar
    [self.navigationController setToolbarHidden:NO animated:YES];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //show bill edit view with detail of bill
    BillEditViewController* billEditor = [[BillEditViewController alloc] init];
    billEditor.bill = [self.dataSource objAtIndexPath:indexPath];
    if (billEditor.bill){
        [self.navigationController pushViewController:billEditor animated:YES];
        [billEditor release];
    }

    [tableView deselectRowAtIndexPath:indexPath 
                             animated:YES];
}

@end
