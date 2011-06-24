//
//  JZBErrorProcessor.h
//  JZB
//
//  Created by Jin Jin on 11-4-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    JZBErrorTypeNullInput,
    JZBErrorTypeFormatError,
    JZBErrorTypeNetWork,
    JZBErrorTypeUnknowError
} JZBErrorType;

@interface JZBErrorProcessor : NSObject {
    
}

@end
