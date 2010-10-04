//
//  ObjCtplBlock.h
//  ObjCtpl
//
//  Created by Joseph Pintozzi on 10/4/10.
//  Copyright 2010 Tiny Dragon Apps LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ObjCtplBlockDelegate

-(NSString *)valueForVariableNamed:(NSString *)name;

@end

@interface ObjCtplBlock : NSObject {
	NSDictionary *subBlocks;
	NSString *name;
	id delegate;
	NSMutableString *html;
	NSMutableString *output;
	NSMutableArray *parsedBlocks;
}

@property (retain) NSString *name;
@property (retain) id delegate;


-(NSString *)parse;
-(NSString *)parseSubblock:(NSString *)sub;
-(id)initWithCode:(NSString *)code;
-(void)setDelegate:(id)del;
-(void)findSubBlocks;

@end
