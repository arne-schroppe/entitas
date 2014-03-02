#import <Foundation/Foundation.h>
#import "ESSystem.h"
#import "ESCollection.h"

@class ESEntity;
@class ESMatcher;
@protocol ESReactiveSubSystem;
@protocol ESReactiveSubSystem4;


@interface ESReactiveSystem4 : NSObject<ESSystem>

@property NSObject<ESReactiveSubSystem4> *clientSystem;
@property (readonly) NSArray *collectedEntities;
@property (readonly) ESEntityChange notificationType;

- (id)initWithSystem:(NSObject <ESReactiveSubSystem4> *)system entityRepository:(ESEntityRepository *)entityRepository;

@end