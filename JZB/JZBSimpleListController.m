//
//  JZBSimpleListController.m
//  JZB
//
//  Created by Jin Jin on 11-4-21.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "JZBSimpleListController.h"


@implementation JZBSimpleListController

@synthesize dataSource = _dataSource;
@synthesize theTableView = _theTableView;
@synthesize delegate = _delegate;
@synthesize delegateSelector = _delegateSelector;
@synthesize managedObj = _managedObj;

#pragma mark - delegate methods for fetched result controller
//begin change
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.theTableView beginUpdates];
}

//end change
-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    [self.theTableView endUpdates];
}

//change happens
- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    switch (type) {
        case NSFetchedResultsChangeDelete:
            [self.theTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                     withRowAnimation:UITableViewRowAnimationLeft];
            break;
        default:
            break;
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
    self.dataSource = nil;
    self.theTableView = nil;
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
    self.theTableView.dataSource = self.dataSource;
    self.dataSource.fetchedController.delegate = self;
    [self refreshList];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.dataSource.checkedCell.accessoryType = UITableViewCellAccessoryNone;
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    self.dataSource.checkedCell = cell;
    [self finishedSelect:[self.dataSource objAtIndexPath:indexPath]];

}

-(void)finishedSelect:(id)obj{
    [self.delegate performSelector:self.delegateSelector
                        withObject:obj];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)newAddNotificationReceived:(NSNotification*)notification{
    NSDictionary* userInfo = notification.userInfo;
    self.dataSource.managedObj = [userInfo objectForKey:@"editObject"];
    [self finishedSelect:self.dataSource.managedObj];
}

-(void)refreshList{
    DebugLog(@"list is refreshed", nil);
    [self.dataSource refresh];
    [self.theTableView reloadData];
}

@end
