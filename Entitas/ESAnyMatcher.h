#import <Foundation/Foundation.h>
#import "ESComponentMatcher.h"


@interface ESAnyMatcher : NSObject<ESComponentMatcher>
- (BOOL)isEqual:(id)other;

- (BOOL)isEqualToMatcher:(ESAnyMatcher *)matcher;

- (NSUInteger)hash;
@end