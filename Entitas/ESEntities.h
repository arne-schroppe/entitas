#import <Foundation/Foundation.h>
#import "ESEntity.h"

@interface ESEntities : NSObject
- (ESEntity *)createEntity;

- (BOOL)containsEntity:(ESEntity *)entity;

- (void)destroyEntity:(ESEntity *)entity;
@end