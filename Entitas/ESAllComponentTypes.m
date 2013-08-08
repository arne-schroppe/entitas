#import <Entitas/ESEntity.h>
#import "ESAllComponentTypes.h"


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