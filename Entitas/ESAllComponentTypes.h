#import <Foundation/Foundation.h>
#import "ESComponentMatcher.h"
#import "ESAbstractComponentMatcher.h"

#define allComponentsOfTypes(...) ([[ESAllComponentTypes alloc] initWithClasses: __VA_ARGS__ ])

@interface ESAllComponentTypes : ESAbstractComponentMatcher
@end