//
//  JZBDataSource.m
//  JZB
//
//  Created by Jin Jin on 11-4-21.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "JZBDataSource.h"
#import "JJObjectManager.h"

@implementation JZBDataSource

@synthesize fetchedController = _fetchedController;
@synthesize modelName = _modelName;
@synthesize predicate = _predicate;
@synthesize managedObj = _managedObj;

//need to override below three methods in sub class
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

-(id)init{
    self = [super init];
    if (self){
        
    }
    
    return self;
}

-(void)dealloc{
    self.fetchedController = nil;
    self.modelName = nil;
    self.predicate = nil;
    [super dealloc];
}

-(void)refresh{
    NSError* error = nil;
    self.fetchedController = nil;
    [self.fetchedController performFetch:&error];
}

-(id)objAtIndexPath:(NSIndexPath*)indexPath{
    id obj = nil;
    @try {
        obj = [self.fetchedController objectAtIndexPath:indexPath];
    }
    @catch (NSException *exception) {
        DebugLog(@"exception happens", nil);
        DebugLog(@"reason is %@" , exception.reason);
        obj = nil;
    }
    
    return obj;
}

-(NSFetchedResultsController*)getFetchedController{
    if (!_fetchedController && self.modelName){
        _fetchedController = [JJObjectManager fetchedResultsControllerFromModel:self.modelName
                                                                      predicate:self.predicate
                                                                sortDescriptors:nil
                                                                        context:nil];
        [_fetchedController retain];
    }
    
    return _fetchedController;
}


@end
