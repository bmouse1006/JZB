//
//  AccountEditViewController.h
//  JZB
//
//  Created by Jin Jin on 11-4-15.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JZBAccounts.h"
#import "JZBEditViewController.h"

@interface AccountEditViewController : JZBEditViewController {
    
    UITableViewCell* _nameCell;
    UITableViewCell* _kindCell;
    UITableViewCell* _initAmtCell;
    
    UILabel* _nameTitle;
    UILabel* _initAmtTitle;
    UILabel* _kindTitle;
    
    UITextField* _nameText;
    UITextField* _initAmtText;
    UILabel*     _kindLabel;
    
    JZBAccounts* _account;
    
    NSString* _kindString;
}

@property (nonatomic, retain) IBOutlet UITableViewCell* nameCell;
@property (nonatomic, retain) IBOutlet UITableViewCell* kindCell;
@property (nonatomic, retain) IBOutlet UITableViewCell* initAmtCell;

@property (nonatomic, retain) IBOutlet UILabel* nameTitle;
@property (nonatomic, retain) IBOutlet UILabel* initAmtTitle;
@property (nonatomic, retain) IBOutlet UILabel* kindTitle;

@property (nonatomic, retain) IBOutlet UITextField* nameText;
@property (nonatomic, retain) IBOutlet UITextField* initAmtText;
@property (nonatomic, retain) IBOutlet UILabel* kindLabel;

@property (nonatomic, retain) JZBAccounts* account;
@property (nonatomic, retain, setter = setKindString:) NSString* kindString;

@end

@interface AccountEditViewController (private)
    
-(void)releaseOutlet;

@end
