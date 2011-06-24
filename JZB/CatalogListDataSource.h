//
//  CatalogListDataSource.h
//  JZB
//
//  Created by Jin Jin on 11-4-21.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JZBDataSource.h"
#import "JZBCatalogs.h"
#import "CatalogListCell.h"

@interface CatalogListDataSource : JZBDataSource {
    CatalogListCell* _tempCell;
    
    NSString* _catalogKind;
}

@property (nonatomic, retain) IBOutlet CatalogListCell* tempCell;
@property (nonatomic, retain, setter = setCatalogKind:) NSString* catalogKind;

@end
