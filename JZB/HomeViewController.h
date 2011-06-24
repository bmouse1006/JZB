//
//  HomeViewController.h
//  JZB
//
//  Created by Jin Jin on 11-4-11.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AccountStatisticController.h"
#import "BudgetViewController.h"

typedef enum {
    HomeViewTypeAccount,
    HomeViewTypeBudget
} HomeViewType ;

@interface HomeViewController : UIViewController {
    
    AccountStatisticController* _accountStatisticController;
    BudgetViewController* _budgetViewController;
    
    UIViewController* _currentViewControler;
    
    UISegmentedControl* _segController;
    UIBarButtonItem* _addItem;
    UIBarButtonItem* _syncItem;
    UIBarButtonItem* _editItem;
    UIBarButtonItem* _configItem;
    UIBarButtonItem* _doneItem;
    
    BOOL _editMode;
    HomeViewType _homeType;
}

@property (nonatomic, retain) UIViewController* currentViewController;

@property (nonatomic, retain) IBOutlet AccountStatisticController* accountStatisticController;
@property (nonatomic, retain) IBOutlet BudgetViewController* budgetViewController;
@property (nonatomic, retain) IBOutlet UISegmentedControl* segController;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* addItem;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* syncItem;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* editItem;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* configItem;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* doneItem;

@property (nonatomic, assign) BOOL editMode;
@property (nonatomic, assign) HomeViewType homeType;

-(void)releaseOutlet;
-(void)releaseController;

-(IBAction)editItemClicked:(id)sender;
-(IBAction)syncItemClicked:(id)sender;
-(IBAction)addItemClicked:(id)sender;
-(IBAction)configItemClicked:(id)sender;
-(IBAction)segItemClicked:(id)sender;

-(void)assemblyUIWithEditMode:(BOOL)editMode;
-(void)localizeViews;

@end
