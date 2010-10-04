//
//  ObjCtplParser.h
//  ObjCtpl
//
//  Created by Joseph Pintozzi on 10/4/10.
//  Copyright 2010 Tiny Dragon Apps LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ObjCtplBlock.h"
#define kVarStart	@"{"
#define kVarEnd		@"}"
#define kBlockStart	@"<!-- BEGIN:"
#define kBlockEnd	@"<!-- END:"
#define kEnder		@"-->"

@interface ObjCtplParser : NSObject <ObjCtplBlockDelegate>{
	NSMutableDictionary *blocks;
	NSMutableDictionary *vars;
	NSString *html;
	NSString *cache;
}

@property (retain) NSString *html;
//@private NSMutableDictionary *blocks;
//@private NSMutableDictionary *vars;

-(id)initWithHTML:(NSString*)code;
-(void)parse:(NSString *)blockName;
-(void)setVar:(NSString*)var withValue:(NSString *)val;
-(void)findBlockInCode:(NSString*)code;
-(NSString *)output;

@end
