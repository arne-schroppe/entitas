#import <Foundation/Foundation.h>
#import "ESComponent.h"

// Handy macro to get an component from entity
// Example: PositionComponent *pos = getComponent(e, PositionComponent);
#define getComponent(entity, ComponentType) ((ComponentType *)[entity componentOfType:[ComponentType class]])

@class ESEntities;

@interface ESEntity : NSObject

@property(strong, nonatomic) ESEntities *entities;
- (void)addComponent:(NSObject <ESComponent> *)component;
- (void)exchangeComponent:(NSObject <ESComponent> *)component;
- (BOOL)containsComponent:(NSObject <ESComponent> *)component;
- (BOOL)hasComponentOfType:(Class)type;
- (void)removeComponentOfType:(Class)type;
- (NSObject <ESComponent> *)componentOfType:(Class)type;
- (BOOL)hasComponentsOfTypes:(NSSet *)types;
- (NSSet *)componentTypes;
- (NSDictionary *)components;
@end