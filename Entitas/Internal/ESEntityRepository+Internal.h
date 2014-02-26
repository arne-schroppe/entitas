#import <Foundation/Foundation.h>
#import "ESEntityRepository.h"

@class ESCollection;

@interface ESEntityRepository (Internal)

- (void)componentOfType:(Class)type hasBeenAddedToEntity:(ESEntity *)entity;

- (void)componentOfType:(Class)type hasBeenExchangedInEntity:(ESEntity *)entity;

- (void)componentOfType:(Class)type hasBeenRemovedFromEntity:(ESEntity *)entity;

- (ESCollection *)collectionForMatcher:(ESMatcher *)matcher;

@end