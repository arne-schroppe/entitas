#import <Foundation/Foundation.h>
#import "ESComponentMatcher.h"
#import "ESAbstractComponentMatcher.h"

#define anyComponentsOfTypes(...) ([[GXAnyComponentType alloc] initWithClasses: __VA_ARGS__ ])

@interface ESAnyComponentType : ESAbstractComponentMatcher
@end