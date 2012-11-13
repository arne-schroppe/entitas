#import "NSNotificationMatcher.h"

@implementation NSNotificationMatcher

+ (id)matcherWithUserInfo:(NSDictionary *)userInfo
{
	return [[NSNotificationMatcher alloc] initWithUserInfo:userInfo];
}

- (id)initWithUserInfo:(NSDictionary *)userInfo
{
	self = [super init];

	if (self)
	{
		_userInfo = userInfo;
	}

	return self;
}

- (BOOL)matches:(id)item
{
	NSNotification *notification = item;
	return ([notification.userInfo isEqual:_userInfo]);
}

@end

@implementation NotificationMatcher

+ (NSArray *)matcherStrings
{
  return @[@"receiveNotification:",
		   @"receiveNotification:withCount:",
		   @"receiveNotification:withCountAtLeast:",
		   @"receiveNotification:withCountAtMost:",
		   @"receiveNotification:withUserInfo:",
		   @"receiveNotification:withCount:userInfo:",
		   @"receiveNotification:withCountAtLeast:userInfo:",
		   @"receiveNotification:withCountAtMost:userInfo:"];
}

- (void)receiveNotification:(NSString *)name
{
	return [self addObserver:name countType:KWCountTypeExact count:1 userInfo:nil];
}

- (void)receiveNotification:(NSString *)name withCount:(NSUInteger)aCount
{
	return [self addObserver:name countType:KWCountTypeExact count:aCount userInfo:nil];
}

- (void)receiveNotification:(NSString *)name withCountAtLeast:(NSUInteger)aCount
{
	return [self addObserver:name countType:KWCountTypeAtLeast count:aCount userInfo:nil];
}

- (void)receiveNotification:(NSString *)name withCountAtMost:(NSUInteger)aCount
{
	return [self addObserver:name countType:KWCountTypeAtMost count:aCount userInfo:nil];
}

- (void)receiveNotification:(NSString *)name withUserInfo:(NSDictionary *)userInfo
{
	return [self addObserver:name countType:KWCountTypeExact count:1 userInfo:userInfo];
}

- (void)receiveNotification:(NSString *)name withCount:(NSUInteger)aCount userInfo:(NSDictionary *)userInfo
{
	return [self addObserver:name countType:KWCountTypeExact count:aCount userInfo:userInfo];
}

- (void)receiveNotification:(NSString *)name withCountAtLeast:(NSUInteger)aCount userInfo:(NSDictionary *)userInfo
{
	return [self addObserver:name countType:KWCountTypeAtLeast count:aCount userInfo:userInfo];
}

- (void)receiveNotification:(NSString *)name withCountAtMost:(NSUInteger)aCount userInfo:(NSDictionary *)userInfo
{
	return [self addObserver:name countType:KWCountTypeAtMost count:aCount userInfo:userInfo];
}

- (void)addObserver:(NSString *)notificationName countType:(KWCountType)aCountType count:(NSUInteger)aCount userInfo:(NSDictionary *)userInfo
{
	if (![self.subject isKindOfClass:[NSNotificationCenter class]])
		[NSException raise:@"KWMatcherException" format:@"subject is not of type -NSNotificationCenter"];

	_notificationName = notificationName;

	KWMessagePattern *messagePattern;

	if (userInfo)
	{
		messagePattern = [KWMessagePattern messagePatternWithSelector:@selector(handleNotification:) argumentFilters:[NSArray arrayWithObject:[NSNotificationMatcher matcherWithUserInfo:userInfo]]];
	}
	else
	{
		messagePattern = [KWMessagePattern messagePatternWithSelector:@selector(handleNotification:)];
	}

	[subject addObserver:self
				selector:@selector(handleNotification:)
					name:_notificationName
				  object:nil];

	@try
	{
		_messageTracker = [KWMessageTracker messageTrackerWithSubject:self messagePattern:messagePattern countType:aCountType count:aCount];
	}
	@catch (NSException *exception)
	{
//        KWSetExceptionFromAcrossInvocationBoundary(exception);
	}
}

- (void)handleNotification:(NSNotification *)notification
{
	NSLog(@"NSNotification received!");
}

- (NSString *)failureMessageForShould {
    return [NSString stringWithFormat:@"expected subject to send notification -%@ %@, but received it %@",
                                      [_messageTracker expectedCountPhrase],
                                      _notificationName,
                                      [_messageTracker receivedCountPhrase]];
}

- (NSString *)failureMessageForShouldNot {
    return [NSString stringWithFormat:@"expected subject not to send notification -%@, but received it %@",
									  _notificationName,
                                      [_messageTracker receivedCountPhrase]];
}

- (BOOL)evaluate
{
	BOOL succeeded = [_messageTracker succeeded];
	[_messageTracker stopTracking];
	[subject removeObserver:self];

	return succeeded;
}

- (BOOL)shouldBeEvaluatedAtEndOfExample
{
	return YES;
}

@end