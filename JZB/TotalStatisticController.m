//
//  TotalStatisticController.m
//  JZB
//
//  Created by Jin Jin on 11-4-12.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "TotalStatisticController.h"
#import "NSDate+Helper.h"
#import "JZBSQLConstants.h"
#import "JZBDataAccessManager.h"
#import "JZBCatalogs.h"

@implementation TotalStatisticController

@synthesize todayLabel = _todayLabel;
@synthesize theWeekAmountLabel = _theWeekAmountLabel;
@synthesize theMonthAmountLabel = _theMonthAmountLabel;
@synthesize todayAmountLabel = _todayAmountLabel;
@synthesize analysisButton = _analysisButton;
@synthesize showBillListButton = _showBillListButton;

-(void)releaseOutlet{
    self.todayAmountLabel = nil;
    self.theWeekAmountLabel = nil;
    self.theMonthAmountLabel = nil;
    self.todayAmountLabel = nil;
    self.analysisButton = nil;
    self.showBillListButton = nil;
}

-(void)reloadAllLabels{
    self.todayLabel.text = [self currentDate];
    double balanceThisWeek = [self balanceForThisWeek];
    double balanceThisMonth = [self balanceForThisMonth];
    double balanceToday = [self balanceForToday];
    
    [self changeLabel:self.theWeekAmountLabel withAmount:balanceThisWeek];
    [self changeLabel:self.theMonthAmountLabel withAmount:balanceThisMonth];
    [self changeLabel:self.todayAmountLabel withAmount:balanceToday];
}

-(IBAction)analysisButtonClicked:(id)sender{
    DebugLog(@"analysis button is clicked", nil);
}

-(IBAction)showBillListButtonClicked:(id)sender{
    DebugLog(@"show bill list button is clicked", nil);
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [self releaseOutlet];
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:NOTIFICATION_NEW_BILL_CREATED
                                                  object:nil];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
//    [self releaseOutlet];
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //set the value for amounts and date
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(reloadAllLabels) 
                                                 name:NOTIFICATION_NEW_BILL_CREATED 
                                               object:nil];
    [self reloadAllLabels];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:NOTIFICATION_NEW_BILL_CREATED
                                                  object:nil];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end

@implementation TotalStatisticController (private)

-(double)balanceForThisMonth{
    NSDate* firstDayOfThisMonth = [[NSDate date] beginningOfMonth];
    DebugLog(@"first day of ths month is %@", [firstDayOfThisMonth description]);
    return [self balanceSinceDate:firstDayOfThisMonth];
}

-(double)balanceForThisWeek{
    NSDate* firstDayOfThisWeek = [[NSDate date] beginningOfWeek];
    DebugLog(@"first day of this week is %@", [firstDayOfThisWeek description]);
    return [self balanceSinceDate:firstDayOfThisWeek];
}

-(double)balanceForToday{
    NSDate* dateForToday = [[NSDate date] beginningOfDay];
    DebugLog(@"date for today is %@", [dateForToday description]);
    DebugLog(@"RFC822 interval is %f", [dateForToday RFC822TimeInteral]);
    return [self balanceSinceDate:dateForToday];
}

-(double)balanceSinceDate:(NSDate*)date{
    //the day before date should be the baseline date
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* component = [[NSDateComponents alloc] init];
    [component setDay:-1];    
    NSDate* beforeDate = [calendar dateByAddingComponents:component 
                                                   toDate:date
                                                  options:0];
    [component release];
    //assembly SQL
    NSString* SQL = [NSString stringWithFormat:SQL_BALANCESINCEDATE, [beforeDate RFC822TimeInteral]];
    //get the result
    NSArray* results = [JZBDataAccessManager fetchResultBySQL:SQL];
    //find the first amount
    double income = 0;
    double expense = 0;
    for (NSDictionary* dic in results){
        NSString* kind = nil;
        NSNumber* amount = nil;
        for (NSString* key in [dic allKeys]){
            if ([key isEqualToString:SQL_COLUMNNAME_CATALOG_KIND]){
                kind = [dic objectForKey:key];
            }
            if ([key isEqualToString:SQL_COLUMNNAME_TOTALAMOUNT]){
                amount = [dic objectForKey:key];
            }
        }
        if ([kind isEqualToString:CATALOG_KIND_INCOME]){
            income += [amount doubleValue];
        }else if ([kind isEqualToString:CATALOG_KIND_EXPEND]){
            expense += [amount doubleValue];
        }
    }
    
    double balance = income - expense;
    
    return balance;
}

-(NSString*)currentDate{
    NSString* output = [NSDateFormatter localizedStringFromDate:[NSDate date] 
                                                      dateStyle:NSDateFormatterMediumStyle
                                                      timeStyle:NSDateFormatterNoStyle];
    return  output;
}

-(void)changeLabel:(UILabel*)label withAmount:(double)amount{
    label.text = [NSString stringWithFormat:@"%.2f", amount];
    if (amount >= 0 ){
        label.textColor = [UIColor greenColor];
    }else{
        label.textColor = [UIColor redColor];
    }
}

@end
