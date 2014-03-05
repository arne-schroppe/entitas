#import "ESReactiveSystemSettings.h"
#import "ESMatcher.h"


@implementation ESReactiveSystemSettings {

}

- (id)init {
	self = [super init];
	if (self) {
		_changeType = ESEntityAdded;
	}

	return self;
}

@end