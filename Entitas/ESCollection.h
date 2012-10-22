#import <Foundation/Foundation.h>
#import "ESEntity.h"


@interface ESCollection : NSObject
- (id)initWithSet:(NSSet *)set;

- (NSSet *)set;

- (void)addEntity:(ESEntity *)entity;

- (NSSet *)entities;

- (void)removeEntity:(ESEntity *)entity;
@end