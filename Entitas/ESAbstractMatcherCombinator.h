#import <Foundation/Foundation.h>
#import "ESComponentMatcher.h"


@interface ESAbstractMatcherCombinator : NSObject<ESComponentMatcher>


- (id)initWithMatchers:(NSObject <ESComponentMatcher> *)firstMatcher, ...;
- (id)initWithSetOfMatchers:(NSSet *)matchers;

- (NSSet *)matchers;

@end