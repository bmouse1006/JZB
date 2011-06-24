//
//  CatalogListCell.h
//  JZB
//
//  Created by Jin Jin on 11-4-21.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JZBCatalogs.h"

@interface CatalogListCell : UITableViewCell {
    JZBCatalogs* _catalog;
}

@property (nonatomic, retain, setter = setCatalog:) JZBCatalogs* catalog;

@end
