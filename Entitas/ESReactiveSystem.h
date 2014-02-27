#import <Foundation/Foundation.h>
#import "ESSystem.h"
#import "ESCollection.h"

@class ESEntity;
@class ESMatcher;
@protocol ESReactiveSystemClient;


//TODO move collecitonobserver to private category
@interface ESReactiveSystem : NSObject<ESSystem, ESCollectionObserver>

@property NSObject<ESReactiveSystemClient> *clientSystem;
@property (readonly) NSArray *collectedEntities;
@property (readonly) ESEntityChange notificationType;

- (id)initWithSystem:(NSObject <ESReactiveSystemClient> *)system entityRepository:(ESEntityRepository *)entityRepository notificationType:(ESEntityChange)type;

@end