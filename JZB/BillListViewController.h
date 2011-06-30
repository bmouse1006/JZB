//
//  BillListViewController.h
//  JZB
//
//  Created by Jin Jin on 11-4-15.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JZBSimpleListController.h"
#import "JZBDataSource.h"
#import "JZBAccounts.h"

@interface BillListViewController : JZBSimpleListController {
//    JZBDataSource* _dataSource;
    JZBAccounts* _account;
    UISegmentedControl* _filterSeg;
//    UITableView* _theTableView;
    
    
    UISearchBar* _mySearchBar;
    UISearchDisplayController* _mySearchDisplayController;
    UIBarButtonItem* _addItem;
    UIBarButtonItem* _editItem;
    UIBarButtonItem* _doneItem;
}

@property (nonatomic, retain) IBOutlet UISegmentedControl* filterSeg;
//@property (nonatomic, retain) IBOutlet UITableView* theTableView;
@property (nonatomic, retain) IBOutlet UISearchBar* mySearchBar;
@property (nonatomic, retain) IBOutlet UISearchDisplayController* mySearchDisplayController;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* addItem;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* editItem;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* doneItem;
//@property (nonatomic, retain, getter = getDataSource) JZBDataSource* dataSource;
@property (nonatomic, retain, setter = setAccount:) JZBAccounts* account;

-(IBAction)filterSegIsClicked:(id)sender;
-(IBAction)addItemIsClicked:(id)sender;
-(IBAction)editItemIsClicked:(id)sender;
-(void)releaseRetainedObjects;
-(void)refreshList;

@end
