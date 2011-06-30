//
//  AccountSimpleListController.h
//  JZB
//
//  Created by Jin Jin on 11-4-21.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JZBSimpleListController.h"

@interface AccountSimpleListController : JZBSimpleListController {
    
    UIBarButtonItem* _addItem;
}

@property (nonatomic, retain) IBOutlet UIBarButtonItem* addItem;

-(IBAction)addItemIsClicked:(id)sender;

@end
