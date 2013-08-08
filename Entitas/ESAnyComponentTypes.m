#import <Entitas/ESEntity.h>
#import "ESAnyComponentTypes.h"


@implementation ESAnyComponentTypes


- (BOOL)areComponentsMatching:(NSSet *)componentTypes {
    return [self.componentTypes intersectsSet:componentTypes];
}

- (NSUInteger)hash {
    return (NSUInteger)self.class + [self.componentTypes hash];
}


@end