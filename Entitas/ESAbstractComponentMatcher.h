#import <Foundation/Foundation.h>
#import "ESComponentMatcher.h"


@interface ESAbstractComponentMatcher : NSObject<ESComponentMatcher>

- (id)initWithClasses:(id)firstClass, ... NS_REQUIRES_NIL_TERMINATION ;
- (id)initWithTypes:(NSSet *)types;

- (NSSet *)componentTypes;

@end