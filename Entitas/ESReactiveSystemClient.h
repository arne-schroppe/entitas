#import <Foundation/Foundation.h>

@class ESMatcher;


@protocol ESReactiveSystemClient <NSObject>

-(void)executeWithEntities:(NSArray *)entities;

-(ESMatcher *)triggeringComponents;

@optional
-(ESMatcher *)mandatoryComponents;


@end