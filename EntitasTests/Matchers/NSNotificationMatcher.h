#import "KWHCMatcher.h"
#import "KWMessageTracker.h"
#import "Kiwi.h"

@interface NSNotificationMatcher : NSObject <HCMatcher>
{
	NSDictionary *_userInfo;
}

+ (id)matcherWithUserInfo:(NSDictionary *)dictionary;

@end

@interface NotificationMatcher : KWMatcher
{
@private
	KWMessageTracker *_messageTracker;
	NSString *_notificationName;
}

- (void)receiveNotification:(NSString *)name;
- (void)receiveNotification:(NSString *)name withCount:(NSUInteger)aCount;
- (void)receiveNotification:(NSString *)name withCountAtLeast:(NSUInteger)aCount;
- (void)receiveNotification:(NSString *)name withCountAtMost:(NSUInteger)aCount;

- (void)receiveNotification:(NSString *)name withUserInfo:(NSDictionary *)userInfo;
- (void)receiveNotification:(NSString *)name withCount:(NSUInteger)aCount userInfo:(NSDictionary *)userInfo;
- (void)receiveNotification:(NSString *)name withCountAtLeast:(NSUInteger)aCount userInfo:(NSDictionary *)userInfo;
- (void)receiveNotification:(NSString *)name withCountAtMost:(NSUInteger)aCount userInfo:(NSDictionary *)userInfo;

@end