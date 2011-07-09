//
//  AccountStatisticController.m
//  JZB
//
//  Created by Jin Jin on 11-4-11.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "AccountStatisticController.h"
#import "AccountEditViewController.h"
#import "BillEditViewController.h"

#define STATISTIC_VIEW_HEIGHT 202

@implementation AccountStatisticController

@synthesize accountListController = _accountListController;
@synthesize totalStatisticController = _totalStatisticController;
@synthesize statisticView = _statisticView;
@synthesize accountListView = _accountListView;
@synthesize image = _image;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

-(void)releaseOutlet{
    self.statisticView = nil;
    self.accountListView = nil;
    self.image = nil;
}

-(void)releaseController{
    self.accountListController = nil; 
    self.totalStatisticController = nil;
}

-(void)addNotificationReceived{
    DebugLog(@"account statistic view add notification received", nil);
    UIViewController* controller = nil;
    //pop up bill add view for non-editing mode
    //pop up account add view for editing mode
    if (self.accountListController.tableView.editing){
        controller = [[AccountEditViewController alloc] init];
    }else{
        controller= [[BillEditViewController alloc] initWithNibName:@"BillEditViewController" bundle:nil];
    }
    
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:controller];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentModalViewController:nav animated:YES];
    
    [nav release];
    [controller release];
}

-(void)editNotificationReceived{
    [self editMode:!self.accountListController.tableView.editing];
}

-(void)editMode:(BOOL)editmode{
    DebugLog(@"switch edit mode", nil);
    CGRect listRect = self.accountListView.frame;
    CGRect statisticRect = self.statisticView.frame;
    CGRect superRect = self.view.frame;
    //fix a strange bug that height of statistic view changes everytime edit button was clicked
    statisticRect.size.height = STATISTIC_VIEW_HEIGHT;
    
    NSString* mTitle = nil;
    if (editmode){
        listRect = superRect;
        statisticRect.origin.y = 0 - statisticRect.size.height;
        mTitle = NSLocalizedString(@"edit_accounts", nil);
    }else{
        //make statistic view back to original position
        statisticRect.origin.y = 0;
        //make the list back to original place and size
        listRect.origin.y = statisticRect.size.height;
        listRect.size.width = superRect.size.width;
        listRect.size.height = superRect.size.height - statisticRect.size.height;
        mTitle = NSLocalizedString(@"all_accounts", nil);
    }
    
    [self.accountListController.tableView setEditing:editmode 
                                            animated:YES];
    self.title = mTitle;
    
    [UIView beginAnimations:@"listEditMode" context:nil];
    [self.accountListView setFrame:listRect];
    [self.statisticView setFrame:statisticRect];
    [UIView commitAnimations];
}

- (void)dealloc
{
    [self releaseController];
    [self releaseOutlet];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NOTIFICATION_EDIT_ITEM_CLICKED
                                                  object:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NOTIFICATION_ADD_ITEM_CLICKED
                                                  object:self];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
//    [self releaseOutlet];
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    //add observer for notification
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(editNotificationReceived) 
                                                 name:NOTIFICATION_EDIT_ITEM_CLICKED 
                                               object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(addNotificationReceived)
                                                 name:NOTIFICATION_ADD_ITEM_CLICKED
                                               object:self];
    //add statistic sub view
    UIView* statView = self.totalStatisticController.view;
    CGRect rect = statView.frame;
    rect.origin.y = 0;
    [statView setFrame:rect];
    [self.statisticView addSubview:statView];
    [self.statisticView sendSubviewToBack:statView];
    //add list sub view 
    UIView* listView = self.accountListController.view;
    rect = listView.frame;
    rect.origin.y = 0;
    [listView setFrame:rect];
    [self.accountListView addSubview:listView];
    //set title for view
    self.title = NSLocalizedString(@"all_accounts", nil);
    
}

- (void)viewDidUnload
{
    [super viewDidUnload]; 
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:NOTIFICATION_EDIT_ITEM_CLICKED
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:NOTIFICATION_ADD_ITEM_CLICKED
                                                  object:nil];
    [self releaseOutlet];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
