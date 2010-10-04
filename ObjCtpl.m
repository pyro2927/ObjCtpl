#import <Foundation/Foundation.h>
#import "ObjCtplParser.h"

int main (int argc, const char * argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

    // insert code here...
    NSLog(@"Hello, World!");
	ObjCtplParser *p = [[ObjCtplParser alloc] initWithHTML:@"<!-- BEGIN: main --><html><head><title>{TITLE}</title></head><body>{MESSAGE}</body></html><!-- END: main -->"];
	[p setVar:@"TITLE" withValue:@"Sample 1"];
	[p setVar:@"MESSAGE" withValue:@"Sample body message"];
	[p parse:@"main"];
	NSLog([p output]);
    [pool drain];
    return 0;
}
