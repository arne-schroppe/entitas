#import "ESAbstractMatcherCombinator.h"


@implementation ESAbstractMatcherCombinator  {
    NSSet *_matchers;
}



- (id)initWithMatchers:(ESMatcher *)firstMatcher, ... {
    va_list args;
    va_start(args, firstMatcher);
    NSMutableSet *matchers = [NSMutableSet new];
    for (ESMatcher *arg = firstMatcher; arg != nil; arg = va_arg(args, id)) {
        [matchers addObject:arg];
    }
    va_end(args);

    return [self initWithSetOfMatchers:matchers];
}


- (id)initWithSetOfMatchers:(NSSet *)matchers {
    self = [super init];
    if (self) {
        _matchers = matchers;
    }

    return self;
}


- (NSSet *)matchers {
    return _matchers;
}



- (NSSet *)componentTypes {
    NSSet *combined = [NSSet set];
    for(ESMatcher *matcher in self.matchers) {
        combined = [combined setByAddingObjectsFromSet:[matcher componentTypes] ];
    }

    return combined;
}



- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![[other class] isEqual:[self class]])
        return NO;

    return [self isEqualToMatcher:other];
}

- (BOOL)isEqualToMatcher:(ESAbstractMatcherCombinator *)matcher {
    if (self == matcher)
        return YES;
    if (matcher == nil)
        return NO;
    if (_matchers != matcher->_matchers && ![_matchers isEqualToSet:matcher->_matchers])
        return NO;
    return YES;
}

- (NSUInteger)hash {
    return [self.class hash] + [_matchers hash];
}


- (id)copyWithZone:(NSZone *)zone
{
    id copy = [[[self class] alloc] initWithSetOfMatchers:[self.matchers copyWithZone:zone]];
    return copy;
}


- (BOOL)areComponentsMatching:(NSSet *)componentTypes {
    @throw [NSException exceptionWithName:NSGenericException reason:@"Must to be implemented in subclass" userInfo:nil];
}

@end