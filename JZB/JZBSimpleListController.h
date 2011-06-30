//
//  JZBSimpleListController.h
//  JZB
//
//  Created by Jin Jin on 11-4-21.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JZBDataSource.h"
#import "JZBManagedObject.h"

@interface JZBSimpleListController : UITableViewController <NSFetchedResultsControllerDelegate> {
    
    JZBDataSource* _dataSource;
    UITableView* _theTableView;
    id _delegate;
    SEL _delegateSelector; 
    JZBManagedObject* _managedObj;
}

@property (nonatomic, retain, getter = getDataSource) JZBDataSource* dataSource;
@property (nonatomic, retain) IBOutlet UITableView* theTableView;
@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) SEL delegateSelector;
@property (nonatomic, retain) JZBManagedObject* managedObj;

-(void)refreshList;
-(void)finishedSelect:(id)obj;
-(void)newAddNotificationReceived:(NSNotification*)notification;

@end
