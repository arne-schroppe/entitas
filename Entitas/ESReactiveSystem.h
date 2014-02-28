#import <Foundation/Foundation.h>
#import "ESSystem.h"
#import "ESCollection.h"

@class ESEntity;
@class ESMatcher;
@protocol ESReactiveSubSystem;


@interface ESReactiveSystem : NSObject<ESSystem>

@property NSObject<ESReactiveSubSystem> *clientSystem;
@property (readonly) NSArray *collectedEntities;
@property (readonly) ESEntityChange notificationType;

- (id)initWithSystem:(NSObject <ESReactiveSubSystem> *)system entityRepository:(ESEntityRepository *)entityRepository notificationType:(ESEntityChange)type;

@end