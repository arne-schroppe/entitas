#import <Foundation/Foundation.h>
#import "ESComponent.h"

#define getComponent(entity, ComponentType) (ComponentType *)[entity getComponentOfType:[ComponentType class]];

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