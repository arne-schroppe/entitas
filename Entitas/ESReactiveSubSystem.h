#import <Foundation/Foundation.h>

@class ESMatcher;


@protocol ESReactiveSubSystem <NSObject>

-(void)executeWithEntities:(NSArray *)entities;

-(ESMatcher *)triggeringComponents;

@optional
-(ESMatcher *)mandatoryComponents;


@end