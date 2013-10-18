#import <Foundation/Foundation.h>


@interface ESMatcher : NSObject <NSCopying>

+ (ESMatcher *)allOf:(Class)firstClass, ... NS_REQUIRES_NIL_TERMINATION;
+ (ESMatcher *)allOfSet:(NSSet *)componentTypes;

+ (ESMatcher *)anyOf:(Class)firstClass, ... NS_REQUIRES_NIL_TERMINATION;
+ (ESMatcher *)anyOfSet:(NSSet *)componentTypes;

+ (ESMatcher *)noneOf:(Class)firstClass, ... NS_REQUIRES_NIL_TERMINATION;
+ (ESMatcher *)noneOfSet:(NSSet *)componentTypes;

+ (ESMatcher *)just:(Class)someClass;


- (ESMatcher *)and:(ESMatcher *)other;
- (ESMatcher *)or:(ESMatcher *)other;
- (ESMatcher *)not;

- (BOOL)areComponentsMatching:(NSSet *)componentTypes;
- (NSSet *)componentTypes;

@end