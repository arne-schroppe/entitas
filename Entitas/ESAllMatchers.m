#import "ESAllMatchers.h"
#import "ESCollection.h"


@implementation ESAllMatchers {
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
    return [_matcher1 areComponentsMatching:componentTypes] && [_matcher2 areComponentsMatching:componentTypes];
}

- (NSSet *)componentTypes {
    return [_matcher1.componentTypes setByAddingObjectsFromSet:_matcher2.componentTypes];
}


- (NSUInteger)hash {
    return (NSUInteger)self.class + [_matcher1 hash] + [_matcher2 hash];
}

- (id)copyWithZone:(NSZone *)zone
{
    id copy = [[[self class] alloc] initWithMatcher:[_matcher1 copyWithZone:zone] and:[_matcher2 copyWithZone:zone]];
    return copy;
}



@end