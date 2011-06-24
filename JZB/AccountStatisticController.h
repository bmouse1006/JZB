//
//  AccountStatisticController.h
//  JZB
//
//  Created by Jin Jin on 11-4-11.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountListViewController.h"
#import "TotalStatisticController.h"

@interface AccountStatisticController : UIViewController {
    AccountListViewController* _accountListController;
    TotalStatisticController* _totalStatisticController;
    
    UIView* _statisticView;
    UIView* _accountListView;
    
    UIImageView* _image;
    
}

@property (nonatomic, retain) IBOutlet UIView* statisticView;
@property (nonatomic, retain) IBOutlet UIView* accountListView;
@property (nonatomic, retain) IBOutlet UIImageView* image;
@property (nonatomic, retain) IBOutlet AccountListViewController* accountListController;
@property (nonatomic, retain) IBOutlet TotalStatisticController* totalStatisticController;

-(void)releaseOutlet;
-(void)releaseController;
//switch the view between edit mode and normal mode
-(void)addNotificationReceived;
-(void)editNotificationReceived;
-(void)editMode:(BOOL)editmode;

@end
