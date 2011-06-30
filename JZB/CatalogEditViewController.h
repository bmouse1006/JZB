//
//  CatalogEditViewController.h
//  JZB
//
//  Created by Jin Jin on 11-4-27.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JZBEditViewController.h"
#import "JZBCatalogs.h"

@interface CatalogEditViewController : JZBEditViewController {
    UITableViewCell* _kindCell;
    UILabel* _kindTitle;
    UILabel* _kindLabel;
    UIButton* _kindButton;
    
    UITableViewCell* _nameCell;
    UILabel* _nameTitle;
    UITextField* _nameText;

    NSString* _catalogKind;
    
    JZBCatalogs* _catalog;
    
}

@property (nonatomic, retain) IBOutlet UITableViewCell* nameCell;
@property (nonatomic, retain) IBOutlet UITableViewCell* kindCell;
@property (nonatomic, retain) IBOutlet UILabel* nameTitle;
@property (nonatomic, retain) IBOutlet UILabel* kindTitle;
@property (nonatomic, retain) IBOutlet UITextField* nameText;
@property (nonatomic, retain) IBOutlet UILabel* kindLabel;
@property (nonatomic, retain) IBOutlet UIButton* kindButton;
@property (nonatomic, retain, getter = getCatalogKind) NSString* catalogKind;
@property (nonatomic, retain) JZBCatalogs* catalog;

//-(IBAction)kindSegIsClicked:(id)sender;
-(void)releaseOutlet;
-(void)localizeViews;

@end
