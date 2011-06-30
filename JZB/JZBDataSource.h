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
    NSPredicate* _predicate;
    NSArray* _sortDescriptors;
    NSString* _sectionNameKeyPath;
    JZBManagedObject* _managedObj;
    
    UITableViewCell* _checkedCell;
}

@property (nonatomic, retain, getter = getFetchedController) NSFetchedResultsController* fetchedController;
//this property should be readonly and subclass should provide get method of this 
@property (nonatomic, readonly, getter = getModelName) NSString* modelName;
@property (nonatomic, retain) NSPredicate* predicate;
@property (nonatomic, retain, getter = getSortDescriptors) NSArray* sortDescriptors;
@property (nonatomic, retain, getter = getSectionNameKeyPath) NSString* sectionNameKeyPath;
@property (nonatomic, retain) JZBManagedObject* managedObj;

@property (nonatomic, retain) UITableViewCell* checkedCell;//cell that has been checked mark

-(void)refresh;
-(id)objAtIndexPath:(NSIndexPath*)indexPath;

//subclass should implement following methods
//-(NSString*)getModelName;

//setup predicate to filt the result

@end
