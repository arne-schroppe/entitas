#import "ESAllMatcher.h"
#import "ESAnyMatcher.h"
#import "ESAllComponentTypes.h"
#import "ESAnyComponentTypes.h"

#define matchAnyOf(...) ([[ESAnyComponentTypes alloc] initWithClasses: __VA_ARGS__, nil ])
#define matchAllOf(...) ([[ESAllComponentTypes alloc] initWithClasses: __VA_ARGS__, nil ])

#define combineWithOR(...) ([[ESAnyMatcher alloc] initWithMatchers: __VA_ARGS__, nil ])
#define combineWithAND(...) ([[ESAllMatcher alloc] initWithMatchers: __VA_ARGS__, nil ])
#define doNotMatch(subMatcher) ([[ESNotMatcher alloc] initWithMatcher: subMatcher ])