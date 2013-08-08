#import "ESAbstractComponentMatcher.h"
#import "ESEntity.h"
#import "ESCollection.h"


@implementation ESAbstractComponentMatcher {
    NSSet *_componentTypes;
}


- (id)initWithClasses:(id)firstClass, ... {

    va_list args;
    va_start(args, firstClass);
    NSMutableSet *componentTypes = [NSMutableSet new];
    for (Class arg = firstClass; arg != nil; arg = va_arg(args, id)) {
        [componentTypes addObject:arg];
    }
    va_end(args);

    return [self initWithTypes:componentTypes];

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