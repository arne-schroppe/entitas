#ifndef __ESCOMPONENT__INCLUDED
#define __ESCOMPONENT__INCLUDED

#import "ESMatcher.h"


@protocol ESComponent <NSObject>

@optional
+ (ESMatcher *)matcher;

@end



@interface ESComponent : NSObject <ESComponent>

+ (ESMatcher *)matcher;

@end


#endif