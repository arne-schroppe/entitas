#import <Entitas/ESEntity.h>
#import "ESAllComponentTypes.h"


@implementation ESAllComponentTypes

- (BOOL)areComponentsMatching:(NSSet *)componentTypes {
    return [self.componentTypes isSubsetOfSet:componentTypes];
}

- (NSUInteger)hash {
    return (NSUInteger)self.class + [self.componentTypes hash];
}


@end