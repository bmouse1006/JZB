//
//  CatalogListCell.m
//  JZB
//
//  Created by Jin Jin on 11-4-21.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "CatalogListCell.h"


@implementation CatalogListCell

@synthesize catalog = _catalog;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCatalog:(JZBCatalogs *)catalog{
    if (_catalog != catalog){
        [_catalog release];
        _catalog = catalog;
        [_catalog retain];
    }
    
    self.textLabel.text = catalog.name;
}

- (void)dealloc
{
    self.catalog = nil;
    [super dealloc];
}

@end
