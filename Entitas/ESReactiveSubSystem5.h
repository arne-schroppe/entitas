#import <Foundation/Foundation.h>

@class ESMatcher;
@class ESReactiveSystemSettings;


@protocol ESReactiveSubSystem5 <NSObject>

- (void)setUp:(ESReactiveSystemSettings *)settings;
- (void)executeWithEntities:(NSArray *)entities;

@end