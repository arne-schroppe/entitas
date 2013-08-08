#import <Foundation/Foundation.h>
#import "ESComponentMatcher.h"
#import "ESAbstractComponentMatcher.h"


@interface ESAnyComponentTypes : ESAbstractComponentMatcher
- (BOOL)isEqual:(id)other;

- (BOOL)isEqualToTypes:(ESAnyComponentTypes *)types;

- (NSUInteger)hash;
@end