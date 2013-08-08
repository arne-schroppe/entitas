#import "ESAllMatcher.h"
#import "ESCollection.h"
#import "ESAnyMatcher.h"


@implementation ESAllMatcher


- (BOOL)areComponentsMatching:(NSSet *)componentTypes {
    for(NSObject<ESComponentMatcher> *matcher in self.matchers) {
        if(![matcher areComponentsMatching:componentTypes]) {
            return NO;
        }
    }
    return YES;
}



@end