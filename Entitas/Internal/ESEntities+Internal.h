#import <Foundation/Foundation.h>
#import "ESEntities.h"

@interface ESEntities (Internal)

- (BOOL)containsEntity:(ESEntity *)entity;

- (void)componentOfType:(Class)type hasBeenAddedToEntity:(ESEntity *)entity;

- (void)componentOfType:(Class)type hasBeenExchangedInEntity:(ESEntity *)entity;

- (void)componentOfType:(Class)type hasBeenRemovedFromEntity:(ESEntity *)entity;

- (NSArray *)allEntities;

@end