//
//  BillEditViewController.m
//  JZB
//
//  Created by Jin Jin on 11-4-8.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "BillEditViewController.h"
#import "JJObjectManager.h"
#import "JZBBills.h"
#import "NSDate+Helper.h"
#import "AccountSimpleListController.h"
#import "CatalogSimpleListController.h"
#import "NSString+JZBHelper.h"
#import "NSDate+Helper.h"

#define BILLMODELNAME @"JZBBills"
#define ACCOUNTMODLELNAME @"JZBAccounts"
#define CATALOGMODELNAME @"JZBCatalogs"

@implementation BillEditViewController

@synthesize catalogList = _catalogList;
@synthesize accountList = _accountList;
@synthesize dateCell = _dateCell;
@synthesize titleCell = _titleCell;
@synthesize amountCell = _amountCell;
@synthesize accountCell = _accountCell;
@synthesize toAccountCell = _toAccountCell;
@synthesize catalogCell = _catalogCell;
@synthesize descCell = _descCell;
@synthesize billTypeSeg = _billTypeSeg;
@synthesize table = _table;
@synthesize segCell = _segCell;
@synthesize dateText = _dateText;
@synthesize amountText = _amountText;
@synthesize titleText = _titleText;
@synthesize descTextView = _descTextView;
@synthesize titleTitle = _titleTitle;
@synthesize dateTitle = _dateTitle;
@synthesize accountTitle = _accountTitle;
@synthesize toAccountTitle = _toAccountTitle;
@synthesize amountTitle = _amountTitle;
@synthesize descTitle = _descTitle;
@synthesize catalogTitle = _catalogTitle;
@synthesize accountLabel = _accountLabel;
@synthesize toAccountLabel = _toAccountLabel;
@synthesize catalogLabel = _catalogLabel;
//@synthesize cellArray = _cellArray;
@synthesize bill = _bill;
@synthesize account = _account;
@synthesize toAccount = _toAccount;
@synthesize catalog = _catalog;
@synthesize billType = _billType;
@synthesize datePicker = _datePicker;
@synthesize context = _context;

-(NSString*)getNotificationName{
    return NOTIFICATION_NEW_BILL_CREATED;
}

-(IBAction)billTypeSegClicked{
    //hide date picker is it's shown
    [self hideDatePicker];
    //change the type
    JZBBillsType type;
    NSInteger index = [self.billTypeSeg selectedSegmentIndex];
    DebugLog(@"index is %d, type is %d", index, self.billType);
    switch (index) {
        case 0:
            type = JZBBillsTypeExpend;
            break;
        case 1:
            type = JZBBillsTypeIncome;
            break;
        case 2:
            type = JZBBillsTypeTransfer;
            break;
        case 3:
            type = JZBBillsTypeLend;
            break;
        default:
            type = JZBBillsTypeExpend;
            break;
    }
    [self changeBillType:type];
}

//call back message for date picker
-(IBAction)datePickerValueChanged:(id)sender{
    self.dateText.text = [NSDateFormatter localizedStringFromDate:self.datePicker.date
                                                        dateStyle:NSDateFormatterMediumStyle
                                                        timeStyle:NSDateFormatterNoStyle];
}

-(IBAction)beginEditDate:(id)sender{
    DebugLog(@"in begin edit date", nil);
    //show date picker 
    [self showDatePicker];
    
}

-(IBAction)endEditDate:(id)sender{
    DebugLog(@"in end edit date", nil);
    //hide date picker
    [self hideDatePicker];
}

-(void)changeBillType:(JZBBillsType)type{
    if (type != self.billType){
        [self resetHeightOfCells];
        self.billType = type;
        //refresh catalog label
        self.catalogList = nil;
        self.catalog = [self.catalogList objectAtIndex:0];
        //refresh the table
        self.cellArray = nil;
        [self.table reloadData];
    }
}

//
-(BOOL)validateInput{
#define VALIDATEMESSAGENUMBER 3
    //put all validte methods to this array
    //and perform them one by one
    //if valid is faild, exception will be thrown and caught
    //Add selector to this array if we need more validate methods
    SEL validateMsg[VALIDATEMESSAGENUMBER] = { @selector(validateAmount), @selector(validateAccount), @selector(validateCatalog)};
    BOOL valid = YES;
    
    @try{
        for (int i = 0; i < VALIDATEMESSAGENUMBER; i++){
            [self performSelector:validateMsg[i]];
        }
    }@catch (NSException* exp) {
        //catch the exception, which means one of valide method failed
        //create an alert view to notify user
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                        message:exp.reason
                                                       delegate:nil
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        valid = NO;
    }@finally {
        //return the validation result
        return valid;
    }
}

-(void)localizeViews{
    JZBLoalizeString(self.dateTitle.text, nil);
    JZBLoalizeString(self.amountTitle.text, nil);
    JZBLoalizeString(self.accountTitle.text, nil);
    JZBLoalizeString(self.catalogTitle.text, nil);
    JZBLoalizeString(self.descTitle.text, nil);
    JZBLoalizeString(self.titleTitle.text, nil);
    JZBLoalizeString(self.titleText.placeholder, nil);
    JZBLoalizeString(self.toAccountTitle.text, nil);
    for (int i = 0; i<self.billTypeSeg.numberOfSegments; i++){
        [self.billTypeSeg setTitle:NSLocalizedString([self.billTypeSeg titleForSegmentAtIndex:i], nil) 
                 forSegmentAtIndex:i];
    }
}

//table view delegate method
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self cellObjAtIndex:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    JZBSimpleListController* list = nil;
    if (cell == self.accountCell){
        //push a list to show all account
        list = [[AccountSimpleListController alloc] initWithNibName:@"AccountSimpleListController"
                                                             bundle:nil];
        list.delegate = self;
        list.delegateSelector = @selector(setAccount:);
        list.managedObj = self.account;
    }else if (cell == self.toAccountCell){
        list = [[AccountSimpleListController alloc] initWithNibName:@"AccountSimpleListController"
                                                             bundle:nil];
        list.delegate = self;
        list.delegateSelector = @selector(setToAccount:);
        list.managedObj = self.toAccount;
    }else if (cell == self.catalogCell){
        list = [[CatalogSimpleListController alloc] initWithNibName:@"CatalogSimpleListController"
                                                             bundle:nil];
        list.delegate = self;
        list.delegateSelector = @selector(setCatalog:);
        list.managedObj = self.catalog;
        //if catalog is nil, setup catalog kind seperatly
        if (self.catalog == nil){
            if (self.billType == JZBBillsTypeExpend){
                ((CatalogSimpleListController*)list).catalogsKind = CATALOG_KIND_EXPEND;
            }else if (self.billType == JZBBillsTypeIncome){
                ((CatalogSimpleListController*)list).catalogsKind = CATALOG_KIND_INCOME;
            }
        }
    }
    if (list){
        [self.navigationController pushViewController:list animated:YES];
    }
    
    [list release];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.cellArray count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[self.cellArray objectAtIndex:section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //adjust the height of cell. Using the height that defined in IB
    UITableViewCell* cell = [self cellObjAtIndex:indexPath];
    return cell.frame.size.height;
}

-(UITableViewCell*)cellObjAtIndex:(NSIndexPath*)indexPath{
    return [[self.cellArray objectAtIndex:indexPath.section] objectAtIndex:[indexPath row]];
}

//getters

-(NSManagedObjectContext*)getManagedObjectContext{
    if (!_context){
        _context = [JJObjectManager context];
        [_context retain];
    }
    
    return _context;
}

-(NSArray*)getCatalogList{
    if (!_catalogList){
        switch(self.billType){
            case JZBBillsTypeIncome:
                _catalogList = [JZBCatalogs catalogsForKind:CATALOG_KIND_INCOME 
                                                    context:self.context];
                break;
            case JZBBillsTypeExpend:
                _catalogList = [JZBCatalogs catalogsForKind:CATALOG_KIND_EXPEND 
                                                    context:self.context];
                break;
            default:
                break;
        }
        
        if (![_catalogList count]){
            _catalogList = nil;
        }
        
        [_catalogList retain];
    }
    
    return _catalogList;
}

-(NSArray*)getAccoutnList{
    if (!_accountList){
        _accountList = [JZBAccounts allManagedObjectsWithcontext:self.context];
        [_accountList retain];
    }

    if (![_accountList count]){
        _accountList = nil;
    }
    
    return _accountList;
}

-(NSArray*)getCellArray{
    //if it's the first time to access table cell, init the cell array first
    if (!_cellArray){
        [_cellArray release];
        DebugLog(@"create a new cell array", nil);
        //create cell for different bill type
        NSArray* section1 = [NSArray arrayWithObjects:self.segCell, nil];;
        NSArray* section2 = nil;
        switch (self.billType) {
            case JZBBillsTypeExpend:
            case JZBBillsTypeIncome:
                //cells for section2
                section2 = [NSArray arrayWithObjects:self.dateCell, self.titleCell,self.amountCell, self.accountCell, self.catalogCell, self.descCell,nil];
                break;
            case JZBBillsTypeTransfer:
                section2 = [NSArray arrayWithObjects:self.dateCell, self.titleCell, self.amountCell, self.accountCell, self.toAccountCell, self.descCell, nil];
                break;
            case JZBBillsTypeLend: 
            case JZBBillsTypeBorrow:
                break;
            default:
                break;
        }
        _cellArray = [NSArray arrayWithObjects:section1, section2, nil];

        [_cellArray retain];
    }
    return _cellArray;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //default bill type is expend
        DebugLog(@"setup default bill type", nil);
        self.billType = JZBBillsTypeExpend;
    }
    return self;
}

- (void)dealloc
{
    [self releaseOutlet];
    [self releaseObjects];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
//    [self releaseOutlet];
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.datePicker.date = [NSDate date];
    self.datePicker.locale = [NSLocale currentLocale];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    [self hideDatePicker];
    CGRect rect = self.table.frame;
    rect.size.height += 200;
    [self.table setFrame:rect];
//    [self showDatePicker];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//implement method of super class
-(void)assemblyResponderArray{
    self.responderArray = [NSArray arrayWithObjects:self.amountText, self.titleText, self.descTextView, nil];
}

-(void)setupInitialValuesForViews{
    if (!self.bill){
        self.dateText.text = [NSDateFormatter localizedStringFromDate:[NSDate date]
                                                            dateStyle:NSDateFormatterMediumStyle
                                                            timeStyle:NSDateFormatterNoStyle];
    }
    
    self.catalog = [self.catalogList objectAtIndex:0];
    self.account = [self.accountList objectAtIndex:0];
    self.toAccount = [self.accountList objectAtIndex:0];
    
}

//self defined setters
-(void)setAccount:(JZBAccounts *)account{
    if (_account != account){
        [_account release];
        //if the context is different, use current context to get the same account again
        //in order to avoid object invalidation
        if ([account managedObjectContext] != nil && self.context != [account managedObjectContext]){
            NSArray* accounts = [JZBAccounts objectsForKey:@"account_id" andValue:account.account_id context:self.context];
            if ([accounts count] > 0){
                _account = [accounts objectAtIndex:0];
            }
        }else{
            _account = account;
        }
        [_account retain];
    }
    //setup label for cell
    if (_account){
        self.accountLabel.text = _account.name;
    }else{
        self.accountLabel.text = NSLocalizedString(@"label_no_account", nil);
    }
}

-(void)setToAccount:(JZBAccounts *)toAccount{
    if (_toAccount != toAccount){
        [_toAccount release];
        //if the context is different, use current context to get the same account again
        //in order to avoid object invalidation
        if ([toAccount managedObjectContext] != nil && self.context != [toAccount managedObjectContext]){
            NSArray* toAccounts = [JZBAccounts objectsForKey:@"account_id" andValue:toAccount.account_id context:self.context];
            if ([toAccounts count] > 0){
                _toAccount = [toAccounts objectAtIndex:0];
            }
        }else{
            _toAccount = toAccount;
        }
        [_toAccount retain];
    }
    //setup label for cell    
    if (_toAccount){
        self.toAccountLabel.text = _toAccount.name;
    }else{
        self.toAccountLabel.text = NSLocalizedString(@"label_no_account", nil);
    }
}

-(void)setCatalog:(JZBCatalogs *)catalog{
    if (_catalog != catalog){
        [_catalog release];
        //if the context is different, use current context to get the same catalog again
        //in order to avoid object invalidation
        if ([catalog managedObjectContext] != nil && self.context != [catalog managedObjectContext]){
            NSArray* catalogs = [JZBCatalogs objectsForKey:@"catalog_id" andValue:catalog.catalog_id context:self.context];
            if ([catalogs count] > 0){
                _catalog = [catalogs objectAtIndex:0];
            }
        }else{
            _catalog = catalog;
        }
        [_catalog retain];
    }
    //renew catalog label
    if (_catalog){
        self.catalogLabel.text = _catalog.name;
    }else{
        self.catalogLabel.text = NSLocalizedString(@"label_no_catalog", nil);
    }
}

@end

@implementation BillEditViewController (private)

-(void)resetHeightOfCells{
    //for grouped table only
    if (self.table.style == UITableViewStyleGrouped){
        for (NSArray* sectinon in self.cellArray){
            //get the first cell in every section
            UITableViewCell* cell = [sectinon objectAtIndex:0];
            //subtract height of cell by 1
            CGRect rect = cell.frame;
            rect.size.height--;
            [cell setFrame:rect];
        }
    }
}

-(void)showDatePicker{
    if (self.picker == nil){
        self.picker = (UIPickerView*)self.datePicker;
    }
    [super showPicker];
//    //setup the date in date picker to show the date in date text field
//    NSDate* date = [NSDate dateFromString:self.dateText.text withFormat:[NSDate dateFormatString]];
//    self.datePicker.date = date;
//    
//    //move up date picker animated
//    CGRect parentRect = self.view.frame;
//    CGRect pickerRect = self.datePicker.frame;
//    pickerRect.origin.y = parentRect.size.height - pickerRect.size.height;
//    [UIView beginAnimations:@"showPicker" context:nil];
//    [self.datePicker setFrame:pickerRect];
//    [UIView commitAnimations];
}

-(void)hideDatePicker{
    if (self.picker == nil){
        self.picker = (UIPickerView*)self.datePicker;
    }
    [super hidePicker];
//    //move down date picker animated
//    CGRect parentRect = self.view.frame;
//    CGRect pickerRect = self.datePicker.frame;
//    pickerRect.origin.y = parentRect.size.height;
//    [UIView beginAnimations:@"hidePicker" context:nil];
//    [self.datePicker setFrame:pickerRect];
//    [UIView commitAnimations];
}

-(void)releaseOutlet{
    self.segCell = nil;
    self.table = nil;
    self.dateCell = nil;
    self.titleCell = nil;
    self.amountCell = nil;
    self.accountCell = nil;
    self.toAccountCell = nil;
    self.catalogCell = nil;
    self.descCell = nil;
    self.billTypeSeg = nil;
    self.amountText = nil;
    self.descTextView = nil;
    self.titleText = nil;
    self.dateText = nil;
    self.cellArray = nil;
    self.accountLabel = nil;
    self.toAccountLabel = nil;
    self.catalogLabel = nil;
    self.dateTitle = nil;
    self.catalogTitle = nil;
    self.accountTitle = nil;
    self.toAccountTitle = nil;
    self.amountTitle = nil;
    self.titleTitle = nil;
    self.descTitle = nil;
}

-(void)releaseObjects{
    self.bill = nil;
    self.account = nil;
    self.toAccount = nil;
    self.catalog = nil;
    self.datePicker = nil;
    [_context release];
    _context = nil;
}
//must be a valid number for amount
-(void)validateAmount{
    if (self.amountText.text == nil || ![self.amountText.text isValidNumber]){
        NSException* exp = [[[NSException alloc] initWithName:@"" reason:@"Please input a valid number" userInfo:nil] autorelease];
        @throw exp;
    }
}
//account can't be nil and from/to account can't be the same one for transfer
-(void)validateAccount{
    NSException* exp = nil;
    //account can't be empty
    if (self.account == nil){
        exp = [[[NSException alloc] initWithName:@"" reason:@"Account can't be empty" userInfo:nil] autorelease];
        @throw exp;
    }
    //validate this while type is transfer
    if (self.billType == JZBBillsTypeTransfer){
        //to-account can't be empty
        if (self.toAccount == nil){
            exp = [[[NSException alloc] initWithName:@"" reason:@"To-account can't be empty" userInfo:nil] autorelease];
            @throw exp;
        }
        //account and to-account can't be the same one
        if (self.account && self.toAccount && [self.account.account_id isEqualToString:self.toAccount.account_id]){
            exp = [[[NSException alloc] initWithName:@"" reason:@"Account and to-account can't be the same account" userInfo:nil] autorelease];
            @throw exp;
        }
    }
}
//catalog can't be nil for income/expense
-(void)validateCatalog{
    NSException* exp = nil;
    if (self.billType == JZBBillsTypeIncome || self.billType == JZBBillsTypeExpend){
        if (self.catalog == nil){
            exp = [[[NSException alloc] initWithName:@"" reason:@"Catalog can't be empty for income or expense" userInfo:nil] autorelease];
            @throw exp;
        }
    }
}


//save bill to DB
-(void)saveJZBObj{
    //save bill
    //create a new model object for bill and setup properties
    JZBBills* bill = (JZBBills*)[JZBBills insertNewManagedObject];
    bill.bill_id = [bill stringForObjectID];
    bill.amount = [NSNumber numberWithDouble:[self.amountText.text doubleValue]];
    bill.title = self.titleText.text;
    bill.version = [NSDate date];
    bill.account_id = self.account.account_id;
    bill.date = [NSDate dateFromString:self.dateText.text withFormat:[NSDate dateFormatString]];
    DebugLog(@"date for bill is %@", [bill.date description]);
    bill.desc = self.descTextView.text;
    bill.month = [NSNumber numberWithInt:4];
    //        bill.month = nil;
    switch (self.billType) {
        case JZBBillsTypeIncome:
            bill.kind = BILL_TYPE_INCOME;
            bill.catalog_id = self.catalog.catalog_id;
            break;
        case JZBBillsTypeExpend:
            bill.kind = BILL_TYPE_EXPEND;
            bill.catalog_id = self.catalog.catalog_id;
            break;
        case JZBBillsTypeTransfer:
            bill.kind = BILL_TYPE_TRANSFER;
            bill.to_account_id = self.toAccount.account_id;
            break;
        case JZBBillsTypeLend:
            bill.kind = BILL_TYPE_LEND;
            bill.borrower_id = nil;
            break;
        default:
            break;
    }
    //save the change
    DebugLog(@"%@", [bill description]);
    [bill persistantChange];

}

@end
