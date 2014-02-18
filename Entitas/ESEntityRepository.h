#import <Foundation/Foundation.h>
#import "ESEntity.h"
#import "ESCollection.h"

@class ESMatcher;


@interface ESEntityRepository : NSObject

- (ESEntity *)createEntity;

- (void)destroyEntity:(ESEntity *)entity;

- (ESCollection *)collectionForTypes:(NSSet *)types;

- (ESCollection *)collectionForMatcher:(ESMatcher *)matcher;

@end