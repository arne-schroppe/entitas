#import <Foundation/Foundation.h>
#import "ESEntity.h"

@class ESEntities;

@interface ESEntity (Internal)

- (instancetype)initWithIndex:(u_long)creationIndex inRepository:(ESEntities *)repository;

- (BOOL)containsComponent:(NSObject <ESComponent> *)component;

- (BOOL)hasComponentOfType:(Class)type;

- (BOOL)hasComponentsOfTypes:(NSSet *)types;

- (NSSet *)componentTypes;

- (u_long)creationIndex;

@end