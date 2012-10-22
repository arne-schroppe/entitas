#import <Foundation/Foundation.h>
#import "ESEntity.h"


@interface ESCollection : NSObject
- (id)initWithTypes:(NSSet *)types;

- (NSSet *)types;

- (void)addEntity:(ESEntity *)entity;

- (NSSet *)entities;

- (void)removeEntity:(ESEntity *)entity;
@end