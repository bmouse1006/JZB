//
//  HomeViewController.m
//  JZB
//
//  Created by Jin Jin on 11-4-11.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "HomeViewController.h"


@implementation HomeViewController

@synthesize segController = _segController;
@synthesize addItem = _addItem;
@synthesize syncItem = _syncItem;
@synthesize configItem = _configItem;
@synthesize editItem = _editItem;
@synthesize accountStatisticController = _accountStatisticController;
@synthesize budgetViewController = _budgetViewController;
@synthesize currentViewController = _currentViewController;
@synthesize editMode = _editMode;
@synthesize doneItem = _doneItem;
@synthesize homeType = _homeType;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.editMode = NO;
        self.homeType = HomeViewTypeAccount;
    }
    return self;
}

- (void)dealloc
{
    [self releaseOutlet];
    [self releaseController];
    [super dealloc];
}

-(void)releaseOutlet{
    self.addItem = nil;
    self.syncItem = nil;
    self.configItem = nil;
    self.editItem = nil;
    self.doneItem = nil;
}

-(void)releaseController{
    self.accountStatisticController = nil;
    self.currentViewController = nil;
    self.budgetViewController = nil;
    self.segController = nil;
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
    //load account statistic view or budget view as content view
    [self segItemClicked:nil];
    //add bar item to tool bar and title bar
    [self assemblyUIWithEditMode:self.editMode];
    // Do any additional setup after loading the view from its nib.
    [self localizeViews];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - action methods

-(IBAction)editItemClicked:(id)sender{
    DebugLog(@"eidt item is clicked", nil);
    self.editMode ^= 1;
    [self assemblyUIWithEditMode:self.editMode];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_EDIT_ITEM_CLICKED
                                                        object:self.currentViewController];
}

-(IBAction)syncItemClicked:(id)sender{
    DebugLog(@"sync item is clicked", nil);    
}

-(IBAction)addItemClicked:(id)sender{
    DebugLog(@"add item is clicked", nil);
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ADD_ITEM_CLICKED 
                                                        object:self.currentViewController];
}

-(IBAction)configItemClicked:(id)sender{
    DebugLog(@"config item is clicked", nil);
}

-(IBAction)segItemClicked:(id)sender{
    DebugLog(@"seg item is clicked", nil);
    switch (self.segController.selectedSegmentIndex) {
        case 0:
            //account screen is selected
            self.currentViewController = self.accountStatisticController;
            self.homeType = HomeViewTypeAccount;
            break;
        case 1:
            //budget is screen selected
            self.currentViewController = self.budgetViewController;
            self.homeType = HomeViewTypeBudget;
            break;
        default:
            break;
    }
    
    self.view = self.currentViewController.view;
    self.title = self.currentViewController.title;
}

-(void)localizeViews{
    for (int i = 0;i<self.segController.numberOfSegments;i++){
        [self.segController setTitle:NSLocalizedString([self.segController titleForSegmentAtIndex:i], nil) forSegmentAtIndex:i];
    }
}

-(void)assemblyUIWithEditMode:(BOOL)editMode{
    
    [self.navigationController setToolbarHidden:editMode animated:YES];
    
    if (editMode){
        [self.navigationItem setLeftBarButtonItem:self.doneItem animated:YES];
        [self.navigationItem setRightBarButtonItem:self.addItem animated:YES];
    }else{
        [self.navigationItem setLeftBarButtonItem:self.editItem animated:YES];
        [self.navigationItem setRightBarButtonItem:self.syncItem animated:YES];
        if (!self.toolbarItems){
            UIBarButtonItem* flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
            UIBarButtonItem* segItem = [[UIBarButtonItem alloc] initWithCustomView:self.segController];
            DebugLog(@"add for seg item is %d", segItem);
            NSArray* items = [NSArray arrayWithObjects:self.addItem, flexItem,  segItem, flexItem, self.configItem,  nil];
            [self setToolbarItems:items animated:YES];
            [segItem release];
            [flexItem release];
        }
    }
    DebugLog(@"title of self.currentViewController is %@", self.currentViewController.title);
    self.title = self.currentViewController.title;
}

@end
