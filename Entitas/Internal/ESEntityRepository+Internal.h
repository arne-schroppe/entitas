#import <Foundation/Foundation.h>
#import "ESEntityRepository.h"

@interface ESEntityRepository (Internal)

- (BOOL)containsEntity:(ESEntity *)entity;

- (void)componentOfType:(Class)type hasBeenAddedToEntity:(ESEntity *)entity;

- (void)componentOfType:(Class)type hasBeenExchangedInEntity:(ESEntity *)entity;

- (void)componentOfType:(Class)type hasBeenRemovedFromEntity:(ESEntity *)entity;

- (NSArray *)allEntities;

@end