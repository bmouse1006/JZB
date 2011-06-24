//
//  CatalogSimpleListController.h
//  JZB
//
//  Created by Jin Jin on 11-4-21.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CatalogListDataSource.h"
#import "JZBSimpleListController.h"
#import "JZBCatalogs.h"

@interface CatalogSimpleListController : JZBSimpleListController {
    UIBarButtonItem* _addItem;
    
    NSString* _catalogsKind;
    
}

@property (nonatomic, retain) UIBarButtonItem* addItem;
@property (nonatomic, retain) NSString* catalogsKind;

-(IBAction)addItemIsClicked:(id)sender;

-(void)releaseOutlet;

@end
