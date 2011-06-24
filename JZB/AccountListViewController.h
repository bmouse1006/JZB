//
//  AccountListViewController.h
//  JZB
//
//  Created by Jin Jin on 11-4-11.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "AccountListDataSource.h"

@interface AccountListViewController : UITableViewController{
    AccountListDataSource* _dataSource;
    UITableView* _theTableView;
}

@property (nonatomic, retain) IBOutlet AccountListDataSource* dataSource;
@property (nonatomic, retain) IBOutlet UITableView* theTableView;

-(void)releaseOutlet;
-(void)releaseControllers;
-(void)refreshList;

@end
