//
//  NSString+JZBHelper.h
//  JZB
//
//  Created by Jin Jin on 11-4-26.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RegexKitLite.h"


@interface NSString (NSString_JZBHelper)

-(BOOL)isValidNumber;
-(BOOL)isFloat;
-(BOOL)isInteger;
-(BOOL)isFloatWithExp;
-(BOOL)isCommaSeperated1;
-(BOOL)isCommaSeperated2;

@end
