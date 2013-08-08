#import <Foundation/Foundation.h>
#import "ESComponentMatcher.h"


@interface ESAllMatchers : NSObject<ESComponentMatcher>
- (BOOL)isEqual:(id)other;

- (BOOL)isEqualToMatchers:(ESAllMatchers *)matchers;

- (NSUInteger)hash;
@end