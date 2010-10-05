#import <Foundation/Foundation.h>
#import "ObjCtplParser.h"
#define BASEURL [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]
#define TEST_TEMPLATE_URL	***PUT YOUR URL HERE***

int main (int argc, const char * argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

    // insert code here...
    //NSLog(@"Hello, World!");
	NSString *html = [NSString stringWithContentsOfURL:[NSURL URLWithString:TEST_TEMPLATE_URL]];
	
	ObjCtplParser *p = [[ObjCtplParser alloc] initWithHTML:html];
	
	[p setVar:@"WEBSITE" withValue:@"www.google.com"];
	[p setVar:@"NAME" withValue:@"test name"];
	[p setVar:@"EMAIL" withValue:@"joe@test.com"];
	[p setVar:@"PHONE" withValue:@"815-790-2927"];
	[p setVar:@"DESCRIPTION" withValue:@"This is a test description"];
	
	[p parse:@"main.email"];
	[p parse:@"main.phone"];
	[p parse:@"main.website"];
	
	[p parse:@"main"];
	NSLog(@"\n\n********************************\n%@",[p output]);
    [pool drain];
    return 0;
}
