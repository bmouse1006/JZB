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
    [self.delegate performSelector:self.delegateSelector
                        withObject:[self.dataSource objAtIndexPath:indexPath]];
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //return to the previous view
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)refreshList{
    DebugLog(@"list is refreshed", nil);
    [self.dataSource refresh];
    [self.theTableView reloadData];
}

@end
