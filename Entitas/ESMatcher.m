#import "ESMatcher.h"
#import "ESCollection.h"


@interface ESNotMatcher : ESMatcher
- (id)initWithMatcher:(ESMatcher *)matcher;
@end

@interface ESAbstractBinaryCombinator : ESMatcher
- (id)initWithMatcher:(ESMatcher *)matcher andOtherMatcher:(ESMatcher *)otherMatcher;
- (ESMatcher *)matcher;
- (ESMatcher *)otherMatcher;
@end

@interface ESAndMatcher : ESAbstractBinaryCombinator
@end

@interface ESOrMatcher : ESAbstractBinaryCombinator
@end


@interface ESSimpleMatcher : ESMatcher
- (id)initWithTypes:(NSSet *)types;
@end

@interface ESAllComponentTypes : ESSimpleMatcher
@end

@interface ESAnyComponentTypes : ESSimpleMatcher
@end



@implementation ESMatcher



+ (ESMatcher *)allOf:(Class)firstClass, ... {
	va_list args;
	va_start(args, firstClass);
	NSMutableSet *componentTypes = [NSMutableSet new];
	for (Class arg = firstClass; arg != nil; arg = va_arg(args, id)) {
		[componentTypes addObject:arg];
	}
	va_end(args);

	return [[ESAllComponentTypes alloc] initWithTypes:componentTypes];
}


+ (ESMatcher *)allOfSet:(NSSet *)componentTypes {
	return [[ESAllComponentTypes alloc] initWithTypes:componentTypes];
}


+ (ESMatcher *)anyOf:(Class)firstClass, ... {
	va_list args;
	va_start(args, firstClass);
	NSMutableSet *componentTypes = [NSMutableSet new];
	for (Class arg = firstClass; arg != nil; arg = va_arg(args, id)) {
		[componentTypes addObject:arg];
	}
	va_end(args);

	return [[ESAnyComponentTypes alloc] initWithTypes:componentTypes];
}


+ (ESMatcher *)anyOfSet:(NSSet *)componentTypes {
	return [[ESAnyComponentTypes alloc] initWithTypes:componentTypes];
}


+ (ESMatcher *)noneOf:(Class)firstClass, ... {
	va_list args;
	va_start(args, firstClass);
	NSMutableSet *componentTypes = [NSMutableSet new];
	for (Class arg = firstClass; arg != nil; arg = va_arg(args, id)) {
		[componentTypes addObject:arg];
	}
	va_end(args);

	return [[[ESAnyComponentTypes alloc] initWithTypes:componentTypes] not];
}


+ (ESMatcher *)noneOfSet:(NSSet *)componentTypes {
	return [[[ESAnyComponentTypes alloc] initWithTypes:componentTypes] not];
}


+ (ESMatcher *)just:(Class)someClass {
    return [[ESAllComponentTypes alloc] initWithTypes:[NSSet setWithObject:someClass]];
}


- (ESMatcher *)and:(ESMatcher *)other {
	return [[ESAndMatcher alloc] initWithMatcher:self andOtherMatcher:other];
}


- (ESMatcher *)or:(ESMatcher *)other {
	return [[ESOrMatcher alloc] initWithMatcher:self andOtherMatcher:other];
}


- (ESMatcher *)not {
	return [[ESNotMatcher alloc] initWithMatcher:self];
}




- (NSSet *)componentTypes {
	return nil;
}

- (NSString *)description {
	return [NSString stringWithFormat:@"<%@: %@>", NSStringFromClass([self class]), [self.componentTypes description]];
}

- (BOOL)areComponentsMatching:(NSSet *)componentTypes {
	@throw [NSException exceptionWithName:NSGenericException reason:@"Must to be implemented in subclass" userInfo:nil];
}


- (id)copyWithZone:(NSZone *)zone {
    id copy = [[[self class] alloc] init];
    return copy;
}



@end





@implementation ESSimpleMatcher {
    NSSet *_componentTypes;
}


- (BOOL)isEqual:(id)other {
    if (other == self) {
        return YES;
    }

    if (!other || ![[other class] isEqual:[self class]]) {
        return NO;
    }

    return [_componentTypes isEqual:[other componentTypes]];
}


- (id)initWithTypes:(NSSet *)types {
    self = [super init];
    if (self) {
        _componentTypes = types;
    }
    return self;
}


- (id)copyWithZone:(NSZone *)zone
{
    id copy = [[[self class] alloc] initWithTypes:[_componentTypes copyWithZone:zone]];
    return copy;
}


- (NSSet *)componentTypes {
    return _componentTypes;
}


@end


@implementation ESAllComponentTypes

- (BOOL)areComponentsMatching:(NSSet *)componentTypes {
	return [self.componentTypes isSubsetOfSet:componentTypes];
}



- (BOOL)isEqual:(id)other {
	if (other == self)
		return YES;
	if (!other || ![[other class] isEqual:[self class]])
		return NO;

	return [self isEqualToTypes:other];
}

- (BOOL)isEqualToTypes:(ESAllComponentTypes *)types {
	if (self == types)
		return YES;
	if (types == nil)
		return NO;
	if (![super isEqual:types])
		return NO;
	return YES;
}

- (NSUInteger)hash {
	return [self.class hash] + 31 * [self.componentTypes hash];
}


@end




@implementation ESAnyComponentTypes

- (BOOL)areComponentsMatching:(NSSet *)componentTypes {
	return [self.componentTypes intersectsSet:componentTypes];
}


- (BOOL)isEqual:(id)other {
	if (other == self)
		return YES;
	if (!other || ![[other class] isEqual:[self class]])
		return NO;

	return [self isEqualToTypes:other];
}

- (BOOL)isEqualToTypes:(ESAnyComponentTypes *)types {
	if (self == types)
		return YES;
	if (types == nil)
		return NO;
	if (![super isEqual:types])
		return NO;
	return YES;
}

- (NSUInteger)hash {
	return [self.class hash] + 31 * [self.componentTypes hash];
}


@end






@implementation ESAbstractBinaryCombinator {
    ESMatcher *_matcher;
    ESMatcher *_otherMatcher;
}


- (id)initWithMatcher:(ESMatcher *)matcher andOtherMatcher:(ESMatcher *)otherMatcher {
    self = [super init];
    if (self) {
        _matcher = matcher;
        _otherMatcher = otherMatcher;
    }

    return self;
}

- (ESMatcher *)matcher {
    return _matcher;
}

- (ESMatcher *)otherMatcher {
    return _otherMatcher;
}


- (NSSet *)componentTypes {
    NSSet *combined = [_matcher componentTypes];
    combined = [combined setByAddingObjectsFromSet:[_otherMatcher componentTypes] ];
    return combined;
}


- (BOOL)isEqual:(id)other {
    if (other == self) {
        return YES;
    }
    if (!other || ![[other class] isEqual:[self class]]) {
        return NO;
    }

    return [self isEqualToCombinator:other];
}

- (BOOL)isEqualToCombinator:(ESAbstractBinaryCombinator *)combinator {
    if (self == combinator) {
        return YES;
    }
    if (combinator == nil) {
        return NO;
    }
    if (!([_matcher isEqual:combinator->_matcher] && [_otherMatcher isEqual:combinator->_otherMatcher]) &&
        !([_matcher isEqual:combinator->_otherMatcher] && [_otherMatcher isEqual:combinator->_matcher])) {
        return NO;
    }
    return YES;
}

- (NSUInteger)hash {
    return [self.class hash] + [_matcher hash] + [_otherMatcher hash];
}


- (id)copyWithZone:(NSZone *)zone
{
    id copy = [[[self class] alloc] initWithMatcher:[_matcher copyWithZone:zone] andOtherMatcher:[_otherMatcher copyWithZone:zone]];
    return copy;
}


- (BOOL)areComponentsMatching:(NSSet *)componentTypes {
    @throw [NSException exceptionWithName:NSGenericException reason:@"Must to be implemented in subclass" userInfo:nil];
}

@end





@implementation ESAndMatcher
- (BOOL)areComponentsMatching:(NSSet *)componentTypes {
    if(![self.matcher areComponentsMatching:componentTypes]) {
        return NO;
    }

    return [self.otherMatcher areComponentsMatching:componentTypes];
}
@end



@implementation ESOrMatcher
- (BOOL)areComponentsMatching:(NSSet *)componentTypes {
    if([self.matcher areComponentsMatching:componentTypes]) {
        return YES;
    }

    return [self.otherMatcher areComponentsMatching:componentTypes];
}
@end



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
	return [self.class hash] + [_matcher hash];
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