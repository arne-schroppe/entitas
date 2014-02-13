#import <Foundation/Foundation.h>
#import "ESEntity.h"
#import "ESCollection.h"

@class ESMatcher;

@interface ESEntities : NSObject
- (ESEntity *)createEntity;
- (BOOL)containsEntity:(ESEntity *)entity;
- (void)destroyEntity:(ESEntity *)entity;
- (ESCollection *)collectionForTypes:(NSSet *)types;
- (NSArray *)allEntities;
@end