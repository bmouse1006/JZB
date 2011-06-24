//
//  NSString+JZBHelper.m
//  JZB
//
//  Created by Jin Jin on 11-4-26.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "NSString+JZBHelper.h"

#define REGEX_INTEGER_PATTERN @"[+\\-]?[0-9]+"
#define REGEX_FLOAT_PATTERN @"[+\\-]?(?:[0-9]*\\.[0-9]+|[0-9]+\\.)"
#define REGEX_FLOAT_WITH_EXPONENT_PATTERN @"[+\\-]?(?:[0-9]*\\.[0-9]+|[0-9]+\\.)(?:[eE][+\\-]?[0-9]+)?"
#define REGEX_COMMA_SEPEATED_1_PATTERN @"[0-9]{1,3}(?:,[0-9]{3})*"
#define REGEX_COMMA_SEPEATED_2_PATTERN @"[0-9]{1,3}(?:,[0-9]{3})*(?:\\.[0-9]+)?"

@implementation NSString (NSString_JZBHelper)

-(BOOL)isValidNumber{
    return [self isFloat] || [self isInteger] || [self isFloatWithExp] || [self isCommaSeperated1] || [self isCommaSeperated2];
}

-(BOOL)isFloat{
    return [self isMatchedByRegex:REGEX_FLOAT_PATTERN]; 
}

-(BOOL)isInteger{
    return [self isMatchedByRegex:REGEX_INTEGER_PATTERN];
}

-(BOOL)isFloatWithExp{
    return [self isMatchedByRegex:REGEX_FLOAT_WITH_EXPONENT_PATTERN];
}

-(BOOL)isCommaSeperated1{
    return [self isMatchedByRegex:REGEX_COMMA_SEPEATED_1_PATTERN];
}

-(BOOL)isCommaSeperated2{
    return [self isMatchedByRegex:REGEX_COMMA_SEPEATED_2_PATTERN];
}

@end
