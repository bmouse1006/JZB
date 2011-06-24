//
//  AccountListViewController.h
//  JZB
//
//  Created by Jin Jin on 11-4-11.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "JZBDataSource.h"

@interface AccountListViewController : UITableViewController{
    JZBDataSource* _dataSource;
    UITableView* _theTableView;
}

@property (nonatomic, retain, getter = getDataSource) JZBDataSource* dataSource;
@property (nonatomic, retain) IBOutlet UITableView* theTableView;

-(void)releaseOutlet;
-(void)releaseControllers;
-(void)refreshList;

@end
