#import <Foundation/Foundation.h>

@class ESMatcher;


@protocol ESReactiveSystemClient <NSObject>

-(void)executeWithEntities:(NSArray *)entities;

-(id)triggeringComponentTypes;

@optional
-(id)mandatoryComponentTypes;


@end