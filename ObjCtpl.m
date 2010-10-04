#import <Foundation/Foundation.h>
#import "ObjCtplParser.h"
#define BASEURL [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]

int main (int argc, const char * argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

    // insert code here...
    NSLog(@"Hello, World!");
	ObjCtplParser *p = [[ObjCtplParser alloc] initWithHTML:@"<!-- BEGIN: main -->\
						<html>\
						<head>\
						<link rel=\"stylesheet\" type=\"text/css\" href=\"shared.css\"/>\
						</head>\
						<body>\
						<div id=\"header\">\
						<!-- BEGIN: logo -->\
						<img src=\"{LOGOSRC}\" name=\"{LOGONAME}\" />\
						<!-- END: logo -->\
						<h1>{NAME}</h1>\
						<!-- BEGIN: website -->\
						<p id=\"website\"><a href=\"{WEBSITE}\">{WEBSITE}</a>\
						<!-- END: website -->\
						</body>\
						</html>\
						<!-- END: main -->"];
	
	
	[p setVar:@"LOGOSRC" withValue:@"http://localhost.jpg"];
	[p setVar:@"LOGONAME" withValue:@"And name!"];
	[p setVar:@"WEBSITE" withValue:@"www.google.com"];
	
	[p parse:@"main.logo"];
	[p parse:@"main.website"];
	
	[p parse:@"main"];
	NSLog(@"\n\n********************************\n%@",[p output]);
    [pool drain];
    return 0;
}
