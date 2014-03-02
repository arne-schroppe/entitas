#import <Foundation/Foundation.h>

@class ESMatcher;


@protocol ESReactiveSubSystem4 <NSObject>

- (void)executeWithEntities:(NSArray *)entities;
- (ESMatcher *)triggeringComponents;

@optional
- (ESEntityChange)notificationType;
- (ESMatcher *)mandatoryComponents;

@end