#import <Foundation/Foundation.h>
#import "ESComponentMatcher.h"
#import "ESAbstractComponentMatcher.h"

#define allComponentsOfTypes(...) ([[GXAllComponentTypes alloc] initWithClasses: __VA_ARGS__ ])

@interface ESAllComponentTypes : ESAbstractComponentMatcher
@end