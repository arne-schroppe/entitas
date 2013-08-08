#import <Foundation/Foundation.h>
#import "ESComponentMatcher.h"
#import "ESAbstractComponentMatcher.h"

#define anyComponentsOfTypes(...) ([[ESAnyComponentType alloc] initWithClasses: __VA_ARGS__ ])

@interface ESAnyComponentTypes : ESAbstractComponentMatcher
@end