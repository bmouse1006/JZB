//
//  AccountEditViewController.m
//  JZB
//
//  Created by Jin Jin on 11-4-15.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "AccountEditViewController.h"
#import "JJObjectManager.h"
#import "JZBDataAccessManager.h"
#import "NSString+JZBHelper.h"

@implementation AccountEditViewController

@synthesize nameCell = _nameCell;
@synthesize initAmtCell = _initAmtCell;
@synthesize kindCell = _kindCell;
@synthesize nameTitle = _nameTitle;
@synthesize initAmtTitle = _initAmtTitle;
@synthesize kindTitle = _kindTitle;
@synthesize account = _account;
@synthesize initAmtText = _initAmtText;
@synthesize kindLabel = _kindLabel;
@synthesize nameText = _nameText;
@synthesize kindString = _kindString;

//set value for kindString, and modify present value of kind label as well
-(void)setKindString:(NSString *)kindString{
    if (_kindString != kindString){
        [_kindString release];
        _kindString = kindString;
        self.kindLabel.text = NSLocalizedString(_kindString, nil);
        [_kindString retain];
    }
}

//create the default cell array if it's nil
-(NSArray*)getCellArray{
    if (!_cellArray){
        NSArray* section1 = [NSArray arrayWithObjects:self.nameCell, self.kindCell, self.initAmtCell, nil];
        _cellArray = [NSArray arrayWithObjects:section1, nil];
        [_cellArray retain];
    }
    
    return _cellArray;
}

-(NSString*)getNotificationName{
    return NOTIFICATOIN_NEW_ACCOUNT_CREATED;
}

//create the default kind array if it's nil
-(NSArray*)getPickerItemsArray{
    if (!_pickerItemsArray){
        NSArray* section1 = [NSArray arrayWithObjects:ACCOUNT_KIND_CASH, ACCOUNT_KIND_BANKCARD, ACCOUNT_KIND_CREDITCARD, ACCOUNT_KIND_STOCK, ACCOUNT_KIND_FUND, ACCOUNT_KIND_OTHER, nil];
        _pickerItemsArray = [NSArray arrayWithObjects:section1, nil];
        [_pickerItemsArray retain];
    }
    
    return _pickerItemsArray;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    //do nothing here
    self.kindString = [self itemForPickerInComponent:component row:row];
}

- (void)dealloc
{
    [self releaseOutlet];
    self.cellArray = nil;
    self.account = nil;
    self.pickerItemsArray = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    //setup init value for sub views 
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(BOOL)validateInput{
    //validate input values for account
    //if failed pop up alter view
    BOOL valid = YES;
    NSString* reason = nil;
    //if name is full of space characters or nil
    if (![[self.nameText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]){
        valid = NO;
        reason = @"name could not be empty";
    }else if (![[self.initAmtText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]){//if init amount is empty
        valid = NO;
        reason = @"init amount could not be empty";
    }else if (![self.initAmtText.text isValidNumber]){//if init amount is not a valid double value
        valid = NO;
        reason = @"init amount is not valid";
    }
    
    if (!valid){
        //pop up alter view
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                        message:reason
                                                       delegate:nil
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    
    return valid;
}

-(void)setupInitialValuesForViews{
    if (self.account){
        self.title = NSLocalizedString(@"title_edit_account", nil);
        self.nameText.text = self.account.name;
        self.initAmtText.text = [NSString stringWithFormat:@"%f", self.account.amount];
        self.kindString = self.account.kind;
    }else{
        self.title = NSLocalizedString(@"title_new_account", nil);
        //setup default value for account kind - cash
        if (!self.kindString){
            self.kindString = ACCOUNT_KIND_CASH;
        }
    }
}

-(void)localizeViews{
    JZBLoalizeString(self.kindTitle.text, nil);
    JZBLoalizeString(self.nameTitle.text, nil);
    JZBLoalizeString(self.initAmtTitle.text, nil);
}

-(void)assemblyResponderArray{
    self.responderArray = [NSArray arrayWithObjects:self.initAmtText, self.nameText, nil];
}

@end

@implementation AccountEditViewController (private)

-(void)releaseOutlet{
    self.nameCell = nil;
    self.kindCell = nil;
    self.initAmtCell = nil;
    self.kindCell = nil;
    self.nameTitle = nil;
    self.initAmtTitle = nil;
    self.kindTitle = nil;
    self.initAmtText = nil;
    self.kindLabel = nil;
    self.nameText = nil;
}

-(void)saveJZBObj{
    //valide input for account value
    JZBAccounts* account = (JZBAccounts*)[JJObjectManager newManagedObjectWithModelName:[JZBAccounts modelName]];
    [account setupDefaultValues];
    account.name = self.nameText.text;
    account.kind = self.kindString;
    NSNumber* amt = [NSNumber numberWithDouble:[self.initAmtText.text doubleValue]]; 
    account.amount = amt;
    
    [JZBDataAccessManager saveManagedObjects:[NSArray arrayWithObject:account]];
    self.editObject = account;
}

@end

