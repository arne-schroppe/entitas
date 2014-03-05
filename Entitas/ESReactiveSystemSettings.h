#import <Foundation/Foundation.h>
#import "ESCollection.h"

@class ESMatcher;


@interface ESReactiveSystemSettings : NSObject

@property ESMatcher *triggeringComponents;
@property ESMatcher *mandatoryComponents;
@property ESEntityChange changeType;

@end