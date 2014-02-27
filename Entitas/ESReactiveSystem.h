#import <Foundation/Foundation.h>
#import "ESSystem.h"
#import "ESCollection.h"

@class ESEntity;
@class ESMatcher;
@protocol ESReactiveSystemClient;


@interface ESReactiveSystem : NSObject<ESSystem>

@property NSObject<ESReactiveSystemClient> *clientSystem;
@property (readonly) NSArray *collectedEntities;
@property (readonly) ESEntityChange notificationType;

- (id)initWithSystem:(NSObject <ESReactiveSystemClient> *)system entityRepository:(ESEntityRepository *)entityRepository notificationType:(ESEntityChange)type;

@end