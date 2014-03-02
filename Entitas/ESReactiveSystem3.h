#import <Foundation/Foundation.h>
#import "ESSystem.h"
#import "ESCollection.h"

@class ESEntity;
@class ESMatcher;
@protocol ESReactiveSubSystem3;


@interface ESReactiveSystem3 : NSObject<ESSystem>

@property (readonly) NSArray *collectedEntities;
@property (readonly) ESEntityChange notificationType;
@property (readonly) ESMatcher *triggerComponents;
@property ESMatcher *mandatoryComponents;

- (id)initWithEntityRepository:(ESEntityRepository *)entityRepository
					 subSystem:(NSObject<ESReactiveSubSystem3> *)subSystem
	notificationType:(ESEntityChange)type
			triggers:(ESMatcher *)triggerComponents;

@end