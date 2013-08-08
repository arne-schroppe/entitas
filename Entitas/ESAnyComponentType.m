#import <Entitas/ESEntity.h>
#import "ESAnyComponentType.h"


@implementation ESAnyComponentType


- (BOOL)areComponentsMatching:(NSSet *)componentTypes {
    return [self.componentTypes intersectsSet:componentTypes];
}


@end