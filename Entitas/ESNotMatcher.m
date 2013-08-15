#import "ESNotMatcher.h"
#import "ESCollection.h"


@implementation ESNotMatcher {
	ESMatcher *_matcher;
}


- (id)initWithMatcher:(ESMatcher *)matcher {
    self = [super init];
    if (self) {
        _matcher = matcher;
    }

    return self;
}

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![[other class] isEqual:[self class]])
        return NO;

    return [self isEqualToMatcher:other];
}

- (BOOL)isEqualToMatcher:(ESNotMatcher *)matcher {
    if (self == matcher)
        return YES;
    if (matcher == nil)
        return NO;
    if (_matcher != matcher->_matcher && ![_matcher isEqual:matcher->_matcher])
        return NO;
    return YES;
}

- (NSUInteger)hash {
    return [_matcher hash];
}



- (BOOL)areComponentsMatching:(NSSet *)componentTypes {
    return ![_matcher areComponentsMatching:componentTypes];
}

- (NSSet *)componentTypes {
    return [_matcher componentTypes];
}

- (id)copyWithZone:(NSZone *)zone {
    id copy = [[[self class] alloc] initWithMatcher:[_matcher copyWithZone:zone]];
    return copy;
}


@end