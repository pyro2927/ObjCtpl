#import <Foundation/Foundation.h>
#import "ObjCtplParser.h"

int main (int argc, const char * argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

    // insert code here...
    NSLog(@"Hello, World!");
	ObjCtplParser *p = [[ObjCtplParser alloc] initWithHTML:@"<!-- BEGIN: main --><html><head><title>{TITLE}</title></head><!-- BEGIN: mid -->** {MESSAGE} **<!-- END: mid --><!-- END: main -->"];
	[p setVar:@"TITLE" withValue:@"Sample 1"];
	
	[p setVar:@"MESSAGE" withValue:@"Sample body message ONE"];
	[p parse:@"main.mid"];
	[p setVar:@"MESSAGE" withValue:@"Sample body message TWO"];
	[p parse:@"main.mid"];
	
	[p parse:@"main"];
	NSLog(@"\n\n********************************\n%@",[p output]);
    [pool drain];
    return 0;
}
