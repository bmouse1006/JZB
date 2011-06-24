//
//  AccountListViewController.m
//  JZB
//
//  Created by Jin Jin on 11-4-11.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "AccountListViewController.h"
#import "JZBDataAccessManager.h"
#import "JJObjectManager.h"

@implementation AccountListViewController

@synthesize dataSource = _dataSource;
@synthesize theTableView = _theTableView;

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

    AccountListDataSource* ds = [[AccountListDataSource alloc] init];
    self.dataSource = ds;
    [ds release];
    
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

-(void)refreshList{
    [self.dataSource refresh];
    [self.theTableView reloadData];
}

@end
