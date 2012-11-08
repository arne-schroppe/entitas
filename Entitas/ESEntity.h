#import <Foundation/Foundation.h>
#import "ESComponent.h"

// Handy macro to get an component from entity
// Example: PositionComponent *pos = getComponent(e, PositionComponent);
#define getComponent(entity, ComponentType) (ComponentType *)[entity getComponentOfType:[ComponentType class]];

// A very lazy programmer can use this macro.
// It not only gets the component from entity but also defines the local variable
// Example: defineComponent(pos, e, PositionComponent)
// Transforms to: PositionComponent *pos = (PositionComponent*)[e getComponentOfType:[PositionComponent class]]
#define defineComponent(name, entity, ComponentType) ComponentType * name = (ComponentType *)[entity getComponentOfType:[ComponentType class]];

@class ESEntities;

@interface ESEntity : NSObject
@property (strong, nonatomic) ESEntities *entities;

- (void)addComponent:(NSObject <ESComponent> *)component;

- (BOOL)containsComponent:(NSObject <ESComponent> *)component;

- (BOOL)hasComponentOfType:(Class)type;

- (void)removeComponentOfType:(Class)type;

- (NSObject <ESComponent> *)getComponentOfType:(Class)type;

- (BOOL)hasComponentsOfTypes:(NSSet *)types;

- (NSSet *)set;
@end