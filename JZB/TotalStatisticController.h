//
//  TotalStatisticController.h
//  JZB
//
//  Created by Jin Jin on 11-4-12.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TotalStatisticController : UIViewController {
    UILabel* _todayLabel;
    UILabel* _theMonthAmountLabel;
    UILabel* _theWeekAmountLabel;
    UILabel* _todayAmountLabel;
    
    UIButton* _analysisButton;
    UIButton* _showBillListButton;
}

@property (nonatomic, retain) IBOutlet UILabel* todayLabel;
@property (nonatomic, retain) IBOutlet UILabel* theMonthAmountLabel;
@property (nonatomic, retain) IBOutlet UILabel* theWeekAmountLabel;
@property (nonatomic, retain) IBOutlet UILabel* todayAmountLabel;
@property (nonatomic, retain) IBOutlet UIButton* analysisButton;
@property (nonatomic, retain) IBOutlet UIButton* showBillListButton;

-(void)releaseOutlet;
-(void)reloadAllLabels;
-(IBAction)analysisButtonClicked:(id)sender;
-(IBAction)showBillListButtonClicked:(id)sender;

@end

@interface TotalStatisticController (private) 

-(double)balanceForThisMonth;
-(double)balanceForThisWeek;
-(double)balanceForToday;
-(double)balanceSinceDate:(NSDate*)date;
-(NSString*)currentDate;
-(void)changeLabel:(UILabel*)label withAmount:(double)amount;

@end
