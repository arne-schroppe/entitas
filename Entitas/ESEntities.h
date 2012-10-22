#import <Foundation/Foundation.h>
#import "ESEntity.h"
#import "ESCollection.h"

@interface ESEntities : NSObject
- (ESEntity *)createEntity;

- (BOOL)containsEntity:(ESEntity *)entity;

- (void)destroyEntity:(ESEntity *)entity;

- (NSArray *)getEntitiesWithComponentsOfTypes:(NSSet *)types;

- (void)componentOfType:(Class)type hasBeenAddedToEntity:(ESEntity *)entity;

- (void)componentOfType:(Class)type hasBeenRemovedFromEntity:(ESEntity *)entity;

- (ESCollection *)getCollectionForTypes:(NSSet *)types;
@end