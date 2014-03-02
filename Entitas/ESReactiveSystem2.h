#import <Foundation/Foundation.h>
#import "ESSystem.h"
#import "ESCollection.h"

@class ESEntity;
@class ESMatcher;
@protocol ESReactiveSubSystem;


@interface ESReactiveSystem2 : NSObject<ESSystem>

@property (readonly) NSArray *collectedEntities;
@property (readonly) ESEntityChange notificationType;
@property (readonly) ESMatcher *triggerComponents;
@property ESMatcher *mandatoryComponents;

- (id)initWithEntityRepository:(ESEntityRepository *)entityRepository
	notificationType:(ESEntityChange)type
			triggers:(ESMatcher *)triggerComponents
		executeBlock:(void(^)(NSArray*))execute;

@end