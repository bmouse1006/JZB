//
//  JZBDataSource.h
//  JZB
//
//  Created by Jin Jin on 11-4-21.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "JZBManagedObject.h"

@interface JZBDataSource : NSObject<UITableViewDataSource> {
    NSFetchedResultsController* _fetchedController;
    NSString* _modelName;
    NSPredicate* _predicate;
    JZBManagedObject* _managedObj;
}

@property (nonatomic, retain, getter = getFetchedController) NSFetchedResultsController* fetchedController;
@property (nonatomic, retain) NSString* modelName;
@property (nonatomic, retain) NSPredicate* predicate;
@property (nonatomic, retain) JZBManagedObject* managedObj;

-(void)refresh;
-(id)objAtIndexPath:(NSIndexPath*)indexPath;

@end
