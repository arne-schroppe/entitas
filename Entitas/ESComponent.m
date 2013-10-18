#import "ESMatcher.h"
#import "ESComponent.h"

@implementation ESComponent

+ (ESMatcher *)matcher {
    return [ESMatcher just:self];
}

@end