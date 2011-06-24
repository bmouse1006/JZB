//
//  AccountListDataSource.h
//  JZB
//
//  Created by Jin Jin on 11-4-20.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JZBDataSource.h"
#import "AccountListCell.h"

@interface AccountListDataSource : JZBDataSource {
    AccountListCell* _tempCell;
}

@property (nonatomic, retain) IBOutlet AccountListCell* tempCell;


@end
