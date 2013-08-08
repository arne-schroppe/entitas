#import <Foundation/Foundation.h>
#import "ESComponentMatcher.h"
#import "ESAbstractComponentMatcher.h"


@interface ESAllComponentTypes : ESAbstractComponentMatcher
- (BOOL)isEqual:(id)other;

- (BOOL)isEqualToTypes:(ESAllComponentTypes *)types;

- (NSUInteger)hash;
@end