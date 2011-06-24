//
//  AccountSimpleListController.m
//  JZB
//
//  Created by Jin Jin on 11-4-21.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "AccountSimpleListController.h"
#import "AccountEditViewController.h"
#import "AccountListDataSource.h"

@implementation AccountSimpleListController

//@synthesize dataSource = _dataSource;
//@synthesize theTableView = _theTableView;
//@synthesize delegate = _delegate;
//@synthesize delegateSelector = _delegateSelector;
@synthesize addItem = _addItem;

-(JZBDataSource*)getDataSource{
    if (!_dataSource){
        _dataSource = [[AccountListDataSource alloc] init];
    }
    
    return _dataSource;
}

-(void)setManagedObj:(JZBManagedObject*)managedObj{
    if (_managedObj != managedObj){
        [_managedObj release];
        _managedObj = managedObj;
        [_managedObj retain];
        
//        ((AccountListDataSource*)self.dataSource).catalogKind = ((JZBCatalogs*)_managedObj).kind;
        ((AccountListDataSource*)self.dataSource).managedObj = _managedObj;
    }
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
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
    self.title = NSLocalizedString(@"accountList", nil);
    self.navigationItem.rightBarButtonItem = self.addItem;
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
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

#pragma mark - IBAction methods
-(IBAction)addItemIsClicked:(id)sender{
    //pop up a view to add new account
    AccountEditViewController* accEdit = [[AccountEditViewController alloc] initWithNibName:@"AccountEditViewController" bundle:nil];
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:accEdit];
    
    [self presentModalViewController:nav animated:YES];
    [nav release];
    [accEdit release];
}

@end
