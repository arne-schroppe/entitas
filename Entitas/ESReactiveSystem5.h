#import <Foundation/Foundation.h>
#import "ESSystem.h"
#import "ESCollection.h"

@class ESEntity;
@class ESMatcher;
@protocol ESReactiveSubSystem5;


@interface ESReactiveSystem5 : NSObject<ESSystem>

@property NSObject<ESReactiveSubSystem5> *clientSystem;
@property (readonly) NSArray *collectedEntities;
@property (readonly) ESEntityChange notificationType;

- (id)initWithSystem:(NSObject <ESReactiveSubSystem5> *)system entityRepository:(ESEntityRepository *)entityRepository;

@end