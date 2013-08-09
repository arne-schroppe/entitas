#import <Foundation/Foundation.h>
#import "ESComponentMatcher.h"


@interface ESNotMatcher : NSObject<ESComponentMatcher>
- (id)initWithMatcher:(NSObject <ESComponentMatcher> *)matcher;


@end