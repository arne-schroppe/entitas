#import "ESAnyMatcher.h"


@implementation ESAnyMatcher


- (BOOL)areComponentsMatching:(NSSet *)componentTypes {
    for(NSObject<ESComponentMatcher> *matcher in self.matchers) {
        if([matcher areComponentsMatching:componentTypes]) {
            return YES;
        }
    }
    return NO;
}


@end