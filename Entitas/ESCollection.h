#import <Foundation/Foundation.h>
#import "ESEntity.h"

extern NSString *const ESEntityAdded;
extern NSString *const ESEntityRemoved;

@interface ESCollection : NSObject
- (id)initWithTypes:(NSSet *)types;
- (NSSet *)types;
- (void)addEntity:(ESEntity *)entity;
- (NSSet *)entities;
- (void)removeEntity:(ESEntity *)entity becauseOfRemovedComponent:(NSObject <ESComponent> *)removedComponent;
@end