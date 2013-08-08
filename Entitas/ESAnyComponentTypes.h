#import <Foundation/Foundation.h>
#import "ESComponentMatcher.h"
#import "ESAbstractComponentMatcher.h"

#define anyComponentsOfTypes(...) ([[ESAnyComponentTypes alloc] initWithClasses: __VA_ARGS__ ])

@interface ESAnyComponentTypes : ESAbstractComponentMatcher
- (BOOL)isEqual:(id)other;

- (BOOL)isEqualToTypes:(ESAnyComponentTypes *)types;

- (NSUInteger)hash;
@end