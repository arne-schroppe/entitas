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


- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![[other class] isEqual:[self class]])
        return NO;

    return [self isEqualToMatchers:other];
}

- (BOOL)isEqualToMatchers:(ESAllMatchers *)matchers {
    if (self == matchers)
        return YES;
    if (matchers == nil)
        return NO;
    if (_matcher1 != matchers->_matcher1 && ![_matcher1 isEqual:matchers->_matcher1])
        return NO;
    if (_matcher2 != matchers->_matcher2 && ![_matcher2 isEqual:matchers->_matcher2])
        return NO;
    return YES;
}

- (NSUInteger)hash {
    NSUInteger hash = [_matcher1 hash];
    hash = hash * 31u + [_matcher2 hash];
    return hash;
}


- (id)copyWithZone:(NSZone *)zone
{
    id copy = [[[self class] alloc] initWithMatcher:[_matcher1 copyWithZone:zone] and:[_matcher2 copyWithZone:zone]];
    return copy;
}



@end