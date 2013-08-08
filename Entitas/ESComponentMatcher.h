#import <Foundation/Foundation.h>

@class ESEntities;
@class ESEntity;

@protocol ESComponentMatcher <NSObject, NSCopying>

- (BOOL)areComponentsMatching:(NSSet *)componentTypes;
- (NSSet *)componentTypes;
//- (NSArray *)matchingEntities:(NSArray*)entities;

@end