#import <Foundation/Foundation.h>

@class ESEntities;
@class ESEntity;

@protocol ESComponentMatcher <NSObject>

- (BOOL)areComponentsMatching:(NSSet *)componentTypes;
//- (NSArray *)matchingEntities:(NSArray*)entities;

@end