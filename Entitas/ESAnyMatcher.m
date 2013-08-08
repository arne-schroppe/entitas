#import "ESAnyMatcher.h"
#import "ESEntity.h"


@implementation ESAnyMatcher {
    NSObject<ESComponentMatcher> *_matcher1;
    NSObject<ESComponentMatcher> *_matcher2;
}


- (id)initWithMatcher:(NSObject<ESComponentMatcher> *)matcher1 and:(NSObject<ESComponentMatcher> *)matcher2 {
    self = [super init];
    if (self) {
        _matcher1 = matcher1;
        _matcher2 = matcher2;
    }

    return self;
}


- (BOOL)areComponentsMatching:(NSSet *)componentTypes {
    return [_matcher1 areComponentsMatching:componentTypes] || [_matcher2 areComponentsMatching:componentTypes];
}


@end