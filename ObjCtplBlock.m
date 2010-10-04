//
//  ObjCtplBlock.m
//  ObjCtpl
//
//  Created by Joseph Pintozzi on 10/4/10.
//  Copyright 2010 Tiny Dragon Apps LLC. All rights reserved.
//

#import "ObjCtplBlock.h"
#import "ObjCtplParser.h"

@implementation ObjCtplBlock
@synthesize name;

-(id)initWithCode:(NSString *)code{
	if (self = [super init]) {
		//check for block header and set name
		// make sure to also check for subblocks
		html = code;
	}
	return self;
}

-(NSString *)parse{
	NSMutableString *cache = [[NSMutableString alloc] initWithString:html];
	
	//look for variables and fill them in
	NSRange range, end;
	NSString *varName = nil;
	NSString *swap = nil;
	range = [cache rangeOfString:kVarStart];
	while (range.location != NSNotFound) {
		end = [cache rangeOfString:kVarEnd];
		varName = [[cache substringToIndex:end.location] substringFromIndex:range.location + 1];
		NSLog(@"Found var named: %@",varName);
		
		//swap out variable
		swap = [NSString stringWithFormat:@"%@%@%@", kVarStart, varName, kVarEnd];
		cache = (NSMutableString *)[cache stringByReplacingOccurrencesOfString:swap withString:[delegate valueForVariableNamed:varName]];
		
		
		//see if we have any more variables to swap out
		range = [cache rangeOfString:kVarStart];
	}
	
	return cache;
}

-(void)setDelegate:(id)del{
	delegate = [del retain];
}

@end
