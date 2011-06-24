//
//  BillListViewController.h
//  JZB
//
//  Created by Jin Jin on 11-4-15.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JZBDataSource.h"

@interface BillListViewController : UIViewController {
    UISegmentedControl* _filterSeg;
    UITableView* _theTableView;
    
    
    UISearchBar* _mySearchBar;
    UISearchDisplayController* _mySearchDisplayController;
}

@property (nonatomic, retain) IBOutlet UISegmentedControl* filterSeg;
@property (nonatomic, retain) IBOutlet UITableView* theTableView;
@property (nonatomic, retain) IBOutlet UISearchBar* mySearchBar;
@property (nonatomic, retain) IBOutlet UISearchDisplayController* mySearchDisplayController;

-(IBAction)filterSegIsClicked:(id)sender;

-(void)releaseOutlet;

@end
