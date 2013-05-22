#import <Foundation/Foundation.h>
#import "ESEntity.h"

@class ESChangedEntity;

extern NSString *const ESEntityAdded;
extern NSString *const ESEntityRemoved;

@interface ESCollection : NSObject
- (id)initWithTypes:(NSSet *)types;

- (NSSet *)types;

- (void)addEntity:(ESChangedEntity *)changedEntity;

- (NSSet *)entities;

- (void)removeEntity:(ESChangedEntity *)changedEntity;
@end