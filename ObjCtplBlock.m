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
		output = [[NSMutableString alloc] init];
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
		//NSLog(@"Sub block, creating with HTML: %@",subHtml);
		ObjCtplBlock *subby = [[ObjCtplBlock alloc] initWithCode: subHtml];
		[subby setName:subName];
		[subBlocks setValue:subby forKey:subName];
		
	}
}

-(NSString *)parse{
	if (!self.delegate) {
		NSLog(@"Error, we have no delegate");
		return @"";
	}
	NSMutableString *cache = [[NSMutableString alloc] initWithString:html];
	//NSLog(@"Parsing subblock with name %@ and html code of %@",self.name, html);
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
	
	output = cache;
	
	//check to see if we need to wrap our subblocks up inside
	NSString *temp = [cache substringFromIndex:[cache rangeOfString:kBlockStart].location + 8];
	NSLog(@"temp: %@",temp);
	NSRange subBlockStart = [temp rangeOfString:kBlockStart];
	if (subBlockStart.location != NSNotFound) {
		//NSLog(@"We found a subblock when parsing");
		//we have some nested stuff we need to wrap up
		NSString *begin = [[temp substringFromIndex:subBlockStart.location] substringToIndex:8 + subBlockStart.length];
		NSLog(@"Begin of next block: ****** %@ ******",begin);
		NSString *pre = [cache substringToIndex:[cache rangeOfString:begin].location];
		NSLog(@"Output prefix: %@",pre);
		//append this prefix to our output
		[output insertString:pre atIndex:0];
		
		//also get what comes after this nested block
		NSRange ender = [temp rangeOfString:kBlockEnd];
		if (ender.location != NSNotFound) {
			NSString *cutOff = [temp substringFromIndex:ender.location];
			ender = [cutOff rangeOfString:kEnder];
			cutOff = [cutOff substringFromIndex:ender.location + ender.length];
			//NSLog(@"After block: %@",cutOff);
			
			[output appendString:cutOff];
		}
		
	}
	NSLog(@"Block named %@ parsed, returning %@",self.name, output);
	return output;
}

-(NSString *)parseSubblock:(NSString *)sub{
	NSLog(@"Parsing subBlock with name: %@",sub);
	//find our blocks
	if ([subBlocks objectForKey:sub]) {
		//we have a block!
		//parse and add to the cache
		ObjCtplBlock *b = (ObjCtplBlock*)[subBlocks objectForKey:sub];
		[b setDelegate:self.delegate];
		[output appendString:[b parse]];
		return output;
	}
	else {
		//check to see if it's a nested block
		NSRange dot = [sub rangeOfString:@"."];
		if (dot.location != NSNotFound) {
			NSString *mainBlock = [sub substringToIndex:dot.location];
			NSString *subby = [sub substringFromIndex:dot.location + dot.length];
			ObjCtplBlock *b = [subBlocks objectForKey:mainBlock];
			[output appendString:[b parseSubblock:subby]];
			return output;
		}
	}
	return @"";
}

-(void)setDelegate:(id)del{
	delegate = [del retain];
}

@end
