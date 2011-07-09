//
//  URLParameterSet.m
//  BreezyReader
//
//  Created by Jin Jin on 10-6-7.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "URLParameterSet.h"

@implementation URLParameterSet

@synthesize parameters = _parameters;

-(NSString*)parameterString{

	NSMutableString* compliedString = [[NSMutableString alloc] init];
	
	NSArray* keys = [self.parameters allKeys];
	
	for (NSString* key in keys){
		
		NSObject* parameter = [self.parameters objectForKey:key];
		
		[compliedString appendString:key];
		[compliedString appendString:@"="];
		
		if ([parameter isKindOfClass:[NSString class]]){
			[compliedString appendString:(NSString*)parameter];
		}
		
		if ([parameter isKindOfClass:[NSDate class]]){
			NSTimeInterval secondes = [(NSDate*)parameter timeIntervalSince1970];
			[compliedString appendFormat:@"%d", secondes];
		}
		
		if ([parameter isKindOfClass:[NSNumber class]]){
			[compliedString appendString:[(NSNumber*)parameter stringValue]];
		}								  
			[compliedString appendString:@"&"];								  
	}
	
	NSMutableString* encodedString = [NSMutableString stringWithCapacity:0];
	[encodedString setString:[compliedString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	
	[encodedString replaceOccurrencesOfString:@"/" 
									withString:@"%2F"
									   options:NSBackwardsSearch
										 range:NSMakeRange(0, [compliedString length])];
	[encodedString replaceOccurrencesOfString:@":" 
									withString:@"%3A"
									   options:NSBackwardsSearch
										 range:NSMakeRange(0, [compliedString length])];
	[compliedString release];
	DebugLog(@"encoded parameter string is %@", encodedString);
	
	return [[[encodedString stringByReplacingOccurrencesOfString:@"?" withString:@"%3F"] retain] autorelease];
}

-(void)setParameterForKey:(NSString*)key withValue:(NSObject*)value{
    if (value == nil){
        value = [NSNull null];
    }
	[self.parameters setObject:value forKey:key];
}

-(id)init{
	if (self = [super init]){
		self.parameters = [NSMutableDictionary dictionary];
	}
	return self;
}

-(void)dealloc{
	[self.parameters release];
	[super dealloc];
}
				
										  

@end
