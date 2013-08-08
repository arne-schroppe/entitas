#import <Foundation/Foundation.h>

@class ESEntities;
@class ESEntity;

@protocol ESComponentMatcher <NSObject>

- (BOOL)isEntityMatching:(ESEntity *)entity;
- (BOOL)areComponentsMatching:(NSSet *)componentTypes;
//- (NSArray *)matchingEntities:(NSArray*)entities;

@end