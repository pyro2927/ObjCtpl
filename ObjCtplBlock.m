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
@synthesize name, delegate;

-(id)initWithCode:(NSString *)code{
	if (self = [super init]) {
		//check for block header and set name
		// make sure to also check for subblocks
		html = code;
		subBlocks = [[NSMutableDictionary alloc] init];
		[self findSubBlocks];
	}
	return self;
}

-(void)findSubBlocks{
	NSString *temp = [html substringFromIndex:[html rangeOfString:kEnder].location + 4];
	NSRange start = [temp rangeOfString:kBlockStart];
	NSRange blockEnd;
	NSRange codeEnd;
	if (start.location != NSNotFound) {
		blockEnd = [temp rangeOfString:kEnder];
		NSString *subName = [[temp substringToIndex:blockEnd.location] substringFromIndex:start.location + start.length];
		subName = [subName stringByReplacingOccurrencesOfString:@" " withString:@""];
		NSLog(@"Found a subBlock with name %@",subName);
		
		//we must find the end of this block
		NSString *commentEnder = [NSString stringWithFormat:@"%@ %@ %@",kBlockEnd, subName, kEnder];
		codeEnd = [temp rangeOfString: commentEnder];
		NSString *subHtml = [[temp substringToIndex:codeEnd.location + codeEnd.length] substringFromIndex:start.location];
		NSLog(@"Sub block, creating with HTML: %@",subHtml);
		ObjCtplBlock *subby = [[ObjCtplBlock alloc] initWithCode: subHtml];
		[subBlocks setValue:subby forKey:subName];
		
	}
}

-(NSString *)parse{
	if (!self.delegate) {
		NSLog(@"Error, we have no delegate");
		return @"";
	}
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

-(NSString *)parseSubblock:(NSString *)sub{
	NSLog(@"Parsing subBlock with name: %@",sub);
	//find our blocks
	if ([subBlocks objectForKey:sub]) {
		//we have a block!
		//parse and add to the cache
		ObjCtplBlock *b = [subBlocks objectForKey:sub];
		[b setDelegate:self.delegate];
		return [b parse];
	}
	else {
		//check to see if it's a nested block
		NSRange dot = [sub rangeOfString:@"."];
		if (dot.location != NSNotFound) {
			NSString *mainBlock = [sub substringToIndex:dot.location];
			NSString *subby = [sub substringFromIndex:dot.location + dot.length];
			ObjCtplBlock *b = [subBlocks objectForKey:mainBlock];
			return [b parseSubblock:subby];
		}
	}
	return @"";
}

-(void)setDelegate:(id)del{
	delegate = [del retain];
}

@end
