//
//  JZBEditViewController.h
//  JZB
//
//  Created by Jin Jin on 11-4-27.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface JZBEditViewController : UIViewController {
    UIBarButtonItem* _cancelItem;
    UIBarButtonItem* _doneItem;
    UITableView* _theTableView;
    
    NSArray* _cellArray;
    NSArray* _responderArray;
    
    UIPickerView* _picker;
    NSArray* _pickerItemsArray;
    
    NSString* _notificationName;
    
}

@property (nonatomic, retain) IBOutlet UIBarButtonItem* cancelItem;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* doneItem;
@property (nonatomic, retain) IBOutlet UITableView* theTableView;
@property (nonatomic, retain, getter = getCellArray) NSArray* cellArray;
@property (nonatomic, retain) IBOutlet UIPickerView* picker;
@property (nonatomic, retain) NSArray* responderArray;
@property (nonatomic, retain, getter = getPickerItemsArray) NSArray* pickerItemsArray;
@property (nonatomic, retain, readonly, getter = getNotificationName) NSString* notificationName;

-(UITableViewCell*)cellObjAtIndex:(NSIndexPath*)indexPath;
//validate input value for accout
-(BOOL)validateInput;
-(IBAction)doneItemIsClicked:(id)sender;
-(IBAction)cancelItemIsClicked:(id)sender;
-(IBAction)showPicker;
-(IBAction)hidePicker;
-(void)localizeViews;
//put all responder to an array in order to resign responder if needed
-(void)assemblyResponderArray;
-(id)itemForPickerInComponent:(NSUInteger)component row:(NSUInteger)row;
-(void)saveJZBObj;
//setup some initial values for some views for the first time use
-(void)setupInitialValuesForViews;

@end
