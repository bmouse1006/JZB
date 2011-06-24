//
//  BillEditViewController.h
//  JZB
//
//  Created by Jin Jin on 11-4-8.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JZBBills.h"
#import "JZBAccounts.h"
#import "JZBCatalogs.h"
#import "JZBEditViewController.h"

@interface BillEditViewController : JZBEditViewController {
    
    UITableView* _table;
    
    UITableViewCell* _segCell;
    UITableViewCell* _dateCell;
    UITableViewCell* _titleCell;
    UITableViewCell* _amountCell;
    UITableViewCell* _accountCell;
    UITableViewCell* _catalogCell;
    UITableViewCell* _descCell;
    UITableViewCell* _toAccountCell;
    
    UISegmentedControl* _billTypeSeg;
    
    UILabel* _dateText;
    UITextField* _titleText;
    UITextField* _amountText;
    UITextView* _descTextView;
    
    UILabel* _accountLabel;
    UILabel* _toAccountLabel;
    UILabel* _catalogLabel;
    
    UILabel* _dateTitle;
    UILabel* _titleTitle;
    UILabel* _amountTitle;
    UILabel* _accountTitle;
    UILabel* _toAccountTitle;
    UILabel* _catalogTitle;
    UILabel* _descTitle;
    
    NSManagedObjectContext* _context;
    JZBBills* _bill;
    JZBAccounts* _account;
    JZBAccounts* _toAccount;
    JZBCatalogs* _catalog;
    
    JZBBillsType _billType;
    
    UIDatePicker* _datePicker;
    
    NSArray* _catalogList;
    NSArray* _accountList;
}

@property (nonatomic, retain, getter = getCatalogList) NSArray* catalogList;
@property (nonatomic, retain, getter = getAccoutnList) NSArray* accountList;

@property (nonatomic, retain) IBOutlet UITableView* table;
@property (nonatomic, retain) IBOutlet UITableViewCell* dateCell;
@property (nonatomic, retain) IBOutlet UITableViewCell* titleCell;
@property (nonatomic, retain) IBOutlet UITableViewCell* amountCell;
@property (nonatomic, retain) IBOutlet UITableViewCell* accountCell;
@property (nonatomic, retain) IBOutlet UITableViewCell* toAccountCell;
@property (nonatomic, retain) IBOutlet UITableViewCell* catalogCell;
@property (nonatomic, retain) IBOutlet UITableViewCell* descCell;
@property (nonatomic, retain) IBOutlet UISegmentedControl* billTypeSeg;
@property (nonatomic, retain) IBOutlet UITableViewCell* segCell;
@property (nonatomic, retain) IBOutlet UILabel* dateText;
@property (nonatomic, retain) IBOutlet UITextField* titleText;
@property (nonatomic, retain) IBOutlet UITextField* amountText;
@property (nonatomic, retain) IBOutlet UITextView* descTextView;
@property (nonatomic, retain) IBOutlet UILabel* dateTitle;
@property (nonatomic, retain) IBOutlet UILabel* titleTitle;
@property (nonatomic, retain) IBOutlet UILabel* amountTitle;
@property (nonatomic, retain) IBOutlet UILabel* accountTitle;
@property (nonatomic, retain) IBOutlet UILabel* toAccountTitle;
@property (nonatomic, retain) IBOutlet UILabel* catalogTitle;
@property (nonatomic, retain) IBOutlet UILabel* descTitle;
@property (nonatomic, retain) IBOutlet UILabel* accountLabel;
@property (nonatomic, retain) IBOutlet UILabel* toAccountLabel;
@property (nonatomic, retain) IBOutlet UILabel* catalogLabel;

//@property (nonatomic, retain, getter = getCellArray) NSArray* cellArray;
@property (nonatomic, readonly, getter = getManagedObjectContext) NSManagedObjectContext* context;
@property (nonatomic, retain) JZBBills* bill;
@property (nonatomic, retain, setter = setAccount:) JZBAccounts* account;
@property (nonatomic, retain, setter = setToAccount:) JZBAccounts* toAccount;
@property (nonatomic, retain, setter = setCatalog:) JZBCatalogs* catalog;

@property (nonatomic, assign) JZBBillsType billType;

@property (nonatomic, retain) IBOutlet UIDatePicker* datePicker;

//IB action messages
-(IBAction)billTypeSegClicked;
-(IBAction)datePickerValueChanged:(id)sender;
-(IBAction)beginEditDate:(id)sender;
-(IBAction)endEditDate:(id)sender;
  
//validate input values for bill, avoiding any null input or illegal input
-(BOOL)validateInput;

//change the type of current editing bill
-(void)changeBillType:(JZBBillsType)type;

//return the array that contains all pre designed cells
-(NSArray*)getCellArray;
//return a cell at location of index path
-(UITableViewCell*)cellObjAtIndex:(NSIndexPath*)indexPath;

@end

@interface BillEditViewController (private)

//to fix a strange bug for cell height changing
-(void)resetHeightOfCells;
//show/hide date picker
-(void)showDatePicker;
-(void)hideDatePicker;
//release all subviews 
-(void)releaseOutlet;
-(void)releaseObjects;

//validation methods
-(void)validateAmount;
-(void)validateAccount;
-(void)validateCatalog;
//save the bill to DB
-(void)saveJZBObj;

@end
