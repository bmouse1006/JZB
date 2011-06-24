//
//  AccountListViewController.m
//  JZB
//
//  Created by Jin Jin on 11-4-11.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "AccountListViewController.h"
#import "BillListViewController.h"
#import "JZBDataAccessManager.h"
#import "JJObjectManager.h"
#import "AccountListDataSource.h"

@implementation AccountListViewController

@synthesize dataSource = _dataSource;
@synthesize theTableView = _theTableView;

-(JZBDataSource*)getDataSource{
    if (!_dataSource){
        _dataSource = [[AccountListDataSource alloc] init];
    }
    
    return _dataSource;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
//        [self refreshDataSource];
    }
    return self;
}

-(void)releaseOutlet{
//    self.tempCell = nil;
    self.theTableView = nil;
}

-(void)releaseControllers{
    self.dataSource = nil;
}

- (void)dealloc
{
    [self releaseOutlet];
    [self releaseControllers];
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:NOTIFICATOIN_NEW_ACCOUNT_CREATED
                                                  object:nil];
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
    
    DebugLog(@"view did load in account list view controller", nil);
    self.theTableView.dataSource = self.dataSource;
    [self refreshList];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshList) 
                                                 name:NOTIFICATOIN_NEW_ACCOUNT_CREATED 
                                               object:nil];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:NOTIFICATOIN_NEW_ACCOUNT_CREATED
                                                  object:nil];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{ 
    
    BillListViewController* billListViewController = [[BillListViewController alloc] initWithNibName:@"BillListViewController" bundle:nil];
    //get related account id
    
    JZBAccounts* account = (JZBAccounts*)[self.dataSource objAtIndexPath:indexPath];
    billListViewController.account = account;
    //get the root navigation controller
    UIWindow* keyWindow = [[UIApplication sharedApplication] keyWindow];
    [(UINavigationController*)keyWindow.rootViewController pushViewController:billListViewController 
                                                                animated:YES];
    
    [billListViewController release];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

-(void)refreshList{
    [self.dataSource refresh];
    [self.theTableView reloadData];
}

@end
