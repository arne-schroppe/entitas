#import <Entitas/ESEntity.h>
#import "ESAnyComponentTypes.h"


@implementation ESAnyComponentTypes


- (BOOL)areComponentsMatching:(NSSet *)componentTypes {
    return [self.componentTypes intersectsSet:componentTypes];
}


@end