#import <Foundation/Foundation.h>


@interface ESMatcher : NSObject <NSCopying>

+ (ESMatcher *)allOf:(id)firstClass, ... NS_REQUIRES_NIL_TERMINATION;
+ (ESMatcher *)allOfSet:(NSSet *)componentTypes;

+ (ESMatcher *)anyOf:(id)firstClass, ... NS_REQUIRES_NIL_TERMINATION;
+ (ESMatcher *)anyOfSet:(NSSet *)componentTypes;

- (ESMatcher *)and:(ESMatcher *)other;
- (ESMatcher *)or:(ESMatcher *)other;
- (ESMatcher *)not;

- (BOOL)areComponentsMatching:(NSSet *)componentTypes;
- (NSSet *)componentTypes;

@end