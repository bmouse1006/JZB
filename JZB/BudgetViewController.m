//
//  BudgetViewController.m
//  JZB
//
//  Created by Jin Jin on 11-4-11.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "BudgetViewController.h"


@implementation BudgetViewController

@synthesize budgetViewController = _budgetViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    self.budgetViewController = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:NOTIFICATION_EDIT_ITEM_CLICKED
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:NOTIFICATION_ADD_ITEM_CLICKED
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
    // Do any additional setup after loading the view from its nib.
    //register add notification
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(editNotificationReceived:) 
                                                 name:NOTIFICATION_EDIT_ITEM_CLICKED
                                               object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(addNotificationReceived:)
                                                 name:NOTIFICATION_ADD_ITEM_CLICKED
                                               object:self];
    [self.view addSubview:self.budgetViewController.view];
    CGRect rect = self.budgetViewController.view.frame;
    rect.origin.y = 0;
    [self.budgetViewController.view setFrame:rect];
    self.title = NSLocalizedString(@"budget", nil);
}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:NOTIFICATION_EDIT_ITEM_CLICKED
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:NOTIFICATION_ADD_ITEM_CLICKED
                                                  object:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//notification selector
-(void)addNotificationReceived:(NSNotification*)notification{
    /////
    DebugLog(@"add notification received", nil);
}

-(void)editNotificationReceived:(NSNotification*)notification{
    DebugLog(@"edit notification received", nil);
}

@end
