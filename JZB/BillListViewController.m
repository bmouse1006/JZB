//
//  BillListViewController.m
//  JZB
//
//  Created by Jin Jin on 11-4-15.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "BillListViewController.h"


@implementation BillListViewController

@synthesize filterSeg = _filterSeg;
@synthesize theTableView = _theTableView;
@synthesize mySearchBar = _mySearchBar;
@synthesize mySearchDisplayController = _mySearchDisplayController;

-(IBAction)filterSegIsClicked:(id)sender{
    DebugLog(@"filter seg is clicked", nil);
}

-(void)releaseOutlet{
    self.filterSeg = nil;
    self.theTableView = nil;
    self.mySearchBar = nil;
    self.mySearchDisplayController = nil;
}

- (void)dealloc
{
    [self releaseOutlet];
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
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.filterSeg];
    self.navigationItem.rightBarButtonItem = rightItem;
    [rightItem release];

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
    [tableView deselectRowAtIndexPath:indexPath 
                             animated:YES];
}

@end
