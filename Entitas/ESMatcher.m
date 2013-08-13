#import "ESMatcher.h"
#import "ESCollection.h"


@interface ESAllComponentTypes : ESMatcher
- (BOOL)isEqual:(id)other;
- (BOOL)isEqualToTypes:(ESAllComponentTypes *)types;
@end


@interface ESAnyComponentTypes : ESMatcher
- (id)initWithClasses:(Class)pClass, ...;
- (BOOL)isEqualToTypes:(ESAnyComponentTypes *)types;
@end



@implementation ESMatcher {
	NSSet *_componentTypes;
}

+ (ESMatcher *)allOf:(id)firstClass, ... {
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


+ (ESMatcher *)anyOf:(id)firstClass, ... {
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



- (ESMatcher *)and:(ESMatcher *)other {
	return nil;
}


- (ESMatcher *)or:(ESMatcher *)other {
	return nil;
}


- (ESMatcher *)not {
	return nil;
}



- (id)initWithTypes:(NSSet *)types {
	self = [super init];
	if (self) {
		_componentTypes = types;
	}
	return self;
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

- (NSSet *)componentTypes {
	return _componentTypes;
}

- (NSString *)description {
	return [NSString stringWithFormat:@"<%@: %@>", NSStringFromClass([self class]), [_componentTypes description]];
}

- (BOOL)areComponentsMatching:(NSSet *)componentTypes {
	@throw [NSException exceptionWithName:NSGenericException reason:@"Must to be implemented in subclass" userInfo:nil];
}

- (id)copyWithZone:(NSZone *)zone
{
	id copy = [[[self class] alloc] initWithTypes:[_componentTypes copyWithZone:zone]];
	return copy;
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
	NSUInteger otherHash = [self.componentTypes hash];
	return [self.class hash] + 31 * otherHash;
}


@end




@implementation ESAnyComponentTypes

- (BOOL)areComponentsMatching:(NSSet *)componentTypes {
	return [self.componentTypes intersectsSet:componentTypes];
}

- (id)initWithClasses:(Class)pClass, ... {
	return  nil;
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