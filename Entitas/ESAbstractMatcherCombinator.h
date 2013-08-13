#import <Foundation/Foundation.h>
#import "ESMatcher.h"


@interface ESAbstractMatcherCombinator : ESMatcher


- (id)initWithMatchers:(ESMatcher *)firstMatcher, ...;
- (id)initWithSetOfMatchers:(NSSet *)matchers;

- (NSSet *)matchers;

@end