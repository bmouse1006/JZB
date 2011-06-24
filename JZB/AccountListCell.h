//
//  AccountListCell.h
//  JZB
//
//  Created by Jin Jin on 11-4-15.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JZBAccounts.h"

@interface AccountListCell : UITableViewCell {
    JZBAccounts* _account;
}

@property (nonatomic, retain, setter = setJZBAccount:) JZBAccounts* account;

-(void)setJZBAccount:(JZBAccounts*)acc;

@end
