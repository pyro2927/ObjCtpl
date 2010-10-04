//
//  ObjCtplParser.m
//  ObjCtpl
//
//  Created by Joseph Pintozzi on 10/4/10.
//  Copyright 2010 Tiny Dragon Apps LLC. All rights reserved.
//

#import "ObjCtplParser.h"

@implementation ObjCtplParser
@synthesize html;

-(id)initWithHTML:(NSString*)code{
	if (self = [super init]) {
		blocks = [[NSMutableDictionary alloc] init];
		vars = [[NSMutableDictionary alloc] init];
		cache = [[NSMutableString alloc] init];
		html = code;
		[self findBlockInCode:html];
	}
	return self;
}

-(void)setVar:(NSString*)var withValue:(NSString *)val{
	if ([vars objectForKey:var]) {
		[vars removeObjectForKey:var];
	}
	[vars setValue:val forKey:var];
}

-(void)parse:(NSString *)blockName{
	//find our blocks
	if ([blocks objectForKey:blockName]) {
		//we have a block!
		//parse and add to the cache
		ObjCtplBlock *b = [blocks objectForKey:blockName];
		[cache appendString:[b parse]];
	}
	else {
		//check to see if it's a nested block
		NSRange dot = [blockName rangeOfString:@"."];
		if (dot.location != NSNotFound) {
			NSString *mainBlock = [blockName substringToIndex:dot.location];
			NSString *subby = [blockName substringFromIndex:dot.location + dot.length];
			ObjCtplBlock *b = [blocks objectForKey:mainBlock];
			[cache appendString:[b parseSubblock:subby]];
		}
	}

}

-(void)findBlockInCode:(NSString*)code{
	//recursively search through the code for all of our blocks
	NSRange range = [code rangeOfString:kBlockStart];
	if (range.location == NSNotFound) {
		//nothing left to find!
		return;
	}
	
	//now look for the end of the block header
	NSRange end = [code rangeOfString:kEnder];
	if (end.location == NSNotFound) {
		//this is a big problem, if we found a block starter, but no ender, something is wrong with the htmlcode
		return;
	}
	
	//otherwise, we got some parsing to do!
	ObjCtplBlock *block = [[ObjCtplBlock alloc] initWithCode:code];
	
	NSString *name = [[code substringToIndex:end.location] substringFromIndex:range.location + range.length];
	
	//remove whitespace
	name = [name stringByReplacingOccurrencesOfString:@" " withString:@""];
	
	[block setName:name];
	[block setDelegate:self];
	
	NSLog(@"Found block with name: %@",name);
	[blocks setObject:block forKey:name];
}

-(NSString *)output{
	return cache;
}

-(NSString *)valueForVariableNamed:(NSString *)name{
	if ([vars valueForKey:name]) {
		return [vars valueForKey:name];
	}
	NSLog(@"No stored variable found for var named: %@",name);
	return @"";
}

@end
