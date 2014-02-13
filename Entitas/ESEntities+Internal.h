#import <Foundation/Foundation.h>
#import "ESEntity.h"
#import "ESEntities.h"
#import "ESCollection.h"

@class ESMatcher;

@interface ESEntities()
- (void)component:(NSObject <ESComponent> *)component ofType:(Class)type hasBeenAddedToEntity:(ESEntity *)entity;
- (void)component:(NSObject <ESComponent> *)component ofType:(Class)type hasBeenExchangedInEntity:(ESEntity *)entity;
- (void)component:(NSObject <ESComponent> *)component ofType:(Class)type hasBeenRemovedFromEntity:(ESEntity *)entity;
- (ESCollection *)collectionForMatcher:(ESMatcher *)matcher;
@end