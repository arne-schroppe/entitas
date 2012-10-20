#import <Foundation/Foundation.h>
#import "ESEntity.h"

@interface ESEntities : NSObject
- (ESEntity *)createEntity;

- (BOOL)containsEntity:(ESEntity *)entity;

- (void)destroyEntity:(ESEntity *)entity;

- (NSArray *)getEntitiesWithComponentsOfTypes:(NSSet *)types;

- (void)componentOfType:(Class)component hasBeenAddedToEntity:(ESEntity *)entity;

- (void)componentOfType:(Class)component hasBeenRemovedFromEntity:(ESEntity *)entity;

@end