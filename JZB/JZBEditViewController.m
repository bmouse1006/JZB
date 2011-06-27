//
//  JZBEditViewController.m
//  JZB
//
//  Created by Jin Jin on 11-4-27.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "JZBEditViewController.h"


@implementation JZBEditViewController

@synthesize cancelItem = _cancelItem;
@synthesize doneItem = _doneItem;
@synthesize theTableView = _theTableView;
@synthesize cellArray = _cellArray;
@synthesize picker = _picker;
@synthesize responderArray = _responderArray;
@synthesize pickerItemsArray = _pickerItemsArray;
@synthesize notificationName = _notificationName;

#pragma mark - methods for IBAction
-(IBAction)doneItemIsClicked:(id)sender{
    if ([self validateInput]){
        BOOL failed = NO;
        @try {
            [self saveJZBObj];
        }
        @catch (NSException *exception) {
            DebugLog(@"Saving failed", nil);
            DebugLog(@"reason is %@", exception.reason);
            failed = YES;
        }
        @finally {
            if (!failed){
                //post a notification saying that new accout has been creatd
                DebugLog(@"send notification with name %@", self.notificationName);
                [[NSNotificationCenter defaultCenter] postNotificationName:self.notificationName
                                                                    object:self];
                //dismiss or pop this modal view
                [self.parentViewController dismissModalViewControllerAnimated:YES];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                //pop up an alert view saying that saving account is failed
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:@"saving failed" 
                                                               delegate:nil
                                                      cancelButtonTitle:@"Cancel"
                                                      otherButtonTitles:nil];
                [alert show];
                [alert release];
            }
        }
    }
}

-(IBAction)cancelItemIsClicked:(id)sender{
    [self.parentViewController dismissModalViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSArray*)getCellArray{
    //sub class need to override this method
    return _cellArray;
}

-(NSString*)getNotificationName{
    return @"no name for parent";
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self assemblyResponderArray];
    [self localizeViews];
    [self setupInitialValuesForViews];
    self.navigationItem.rightBarButtonItem = self.cancelItem;
    self.navigationItem.leftBarButtonItem = self.doneItem;
    [self hidePicker];

}

#pragma mark - table view delegates
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self cellObjAtIndex:indexPath];
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

#pragma mark - picker view delegates

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return 150;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return NSLocalizedString([self itemForPickerInComponent:component row:row], nil);
}

#pragma mark - picker view datasource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return [self.pickerItemsArray count];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [[self.pickerItemsArray objectAtIndex:component] count];
}

-(id)itemForPickerInComponent:(NSUInteger)component row:(NSUInteger)row{
    return [[self.pickerItemsArray objectAtIndex:component] objectAtIndex:row];
}

-(IBAction)hidePicker{
    DebugLog(@"hide picker", nil);
    CGRect pickerRect = self.picker.frame;
    CGRect viewRect = self.view.frame;
    pickerRect.origin.y = viewRect.size.height;
    [UIView beginAnimations:@"hidePicker" context:nil];
    [self.picker setFrame:pickerRect];
    [UIView commitAnimations];
}

-(IBAction)showPicker{
    DebugLog(@"show picker", nil);
    [self.responderArray makeObjectsPerformSelector:@selector(resignFirstResponder)];
    CGRect pickerRect = self.picker.frame;
    CGRect viewRect = self.view.frame;
    pickerRect.origin.y = viewRect.size.height - pickerRect.size.height;
    [UIView beginAnimations:@"showPicker" context:nil];
    [self.picker setFrame:pickerRect];
    [UIView commitAnimations];
}

-(BOOL)validateInput{
    return YES;
}

-(void)localizeViews{
    //nothing here
}

-(void)saveJZBObj{
    //nothing
}

-(void)dealloc{
    self.cancelItem = nil;
    self.doneItem = nil;
    self.theTableView = nil;
    self.cellArray = nil;
    self.picker = nil;
    self.responderArray = nil;
    self.pickerItemsArray = nil;
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)assemblyResponderArray{
    //do nothing here
}

-(void)setupInitialValuesForViews{
    //do nothing here
}



@end
