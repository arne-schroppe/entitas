#ifndef __ESMATCHER__INCLUDED
#define __ESMATCHER__INCLUDED

#import "ESMatcher.h"


@protocol ESComponent <NSObject>

@optional
+ (ESMatcher *)matcher;

@end



@interface ESComponent : NSObject <ESComponent>

+ (ESMatcher *)matcher;

@end


#endif