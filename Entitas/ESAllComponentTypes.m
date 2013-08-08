#import <Entitas/ESEntity.h>
#import "ESAllComponentTypes.h"


@implementation ESAllComponentTypes

- (BOOL)areComponentsMatching:(NSSet *)componentTypes {
    return [self.componentTypes isSubsetOfSet:componentTypes];
}


@end