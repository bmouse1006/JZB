//
//  CatalogSimpleListController.m
//  JZB
//
//  Created by Jin Jin on 11-4-21.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "CatalogSimpleListController.h"
#import "CatalogEditViewController.h"
#import "CatalogListDataSource.h"

@implementation CatalogSimpleListController

@synthesize addItem = _addItem;
@synthesize catalogsKind = _catalogsKind;

-(JZBDataSource*)getDataSource{
    if (!_dataSource){
        _dataSource = [[CatalogListDataSource alloc] init];
    }
    
    return _dataSource;
}

-(void)setManagedObj:(JZBManagedObject*)managedObj{
    if (_managedObj != managedObj){
        [_managedObj release];
        _managedObj = managedObj;
        [_managedObj retain];
        
        [self.dataSource setValue:_managedObj forKey:@"managedObj"];
        self.catalogsKind = [_managedObj valueForKey:@"kind"];
    }
}

-(void)setCatalogsKind:(NSString *)catalogsKind{
    if (_catalogsKind != catalogsKind){
        [_catalogsKind release];
        _catalogsKind = catalogsKind;
        [_catalogsKind retain];
        
        [self.dataSource setValue:_catalogsKind forKey:@"catalogKind"];
        
    }
}

-(void)releaseOutlet{
    self.addItem = nil;
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
    [self releaseOutlet];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:NOTIFICATION_NEW_CATALOG_CREATED
                                                  object:nil];
    self.catalogsKind = nil;
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
    
    NSString* title = NSLocalizedString(@"catalogList", nil);
    if (self.catalogsKind != nil){
        title = [title stringByAppendingFormat:@" %@", NSLocalizedString(self.catalogsKind, nil)];
    }

    self.title = title;
    self.navigationItem.rightBarButtonItem = self.addItem;
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(newAddNotificationReceived:)
                                                 name:NOTIFICATION_NEW_CATALOG_CREATED 
                                               object:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:NOTIFICATION_NEW_CATALOG_CREATED
                                                  object:nil];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction)addItemIsClicked:(id)sender{
    DebugLog(@"add item in catalog list is clicked", nil);
    //pop up a view to add a new catalog
    CatalogEditViewController* catalogEdit = [[CatalogEditViewController alloc] initWithNibName:@"CatalogEditViewController" bundle:nil];
    catalogEdit.isNew = YES;
    catalogEdit.catalogKind = self.catalogsKind;
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:catalogEdit];
    [self presentModalViewController:nav animated:YES];
    [catalogEdit release];
    [nav release];
}

@end
