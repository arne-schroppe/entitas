#import <Foundation/Foundation.h>
#import "ESEntity.h"
#import "ESCollection.h"

@class ESMatcher;


@interface ESEntities : NSObject
- (ESEntity *)createEntity;

- (BOOL)containsEntity:(ESEntity *)entity;

- (void)destroyEntity:(ESEntity *)entity;

- (void)component:(NSObject <ESComponent> *)component ofType:(Class)type hasBeenAddedToEntity:(ESEntity *)entity;
- (void)component:(NSObject <ESComponent> *)component ofType:(Class)type hasBeenExchangedInEntity:(ESEntity *)entity;

- (void)component:(NSObject <ESComponent> *)component ofType:(Class)type hasBeenRemovedFromEntity:(ESEntity *)entity;

- (ESCollection *)collectionForTypes:(NSSet *)types;
- (ESCollection *)collectionForMatcher:(ESMatcher *)matcher;

- (NSArray *)allEntities;
@end