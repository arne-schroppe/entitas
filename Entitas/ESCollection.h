#import <Foundation/Foundation.h>
#import "ESEntity.h"

@class ESChangedEntity;
@protocol ESCollectionObserver;

extern NSString *const ESEntityAdded;
extern NSString *const ESEntityRemoved;

@interface ESCollection : NSObject
- (id)initWithTypes:(NSSet *)types;

- (NSSet *)types;

- (void)addEntity:(ESChangedEntity *)changedEntity;

- (NSSet *)entities;

- (void)removeEntity:(ESChangedEntity *)changedEntity;

- (void)addObserver:(id <ESCollectionObserver>)observer forEvent:(NSString * const)event;

- (void)removeObserver:(id <ESCollectionObserver>)observer forEvent:(NSString * const)event;
@end


@protocol ESCollectionObserver

- (void)entity:(ESChangedEntity *)changedEntity changedInCollection:(ESCollection *)collection withEvent:(NSString * const)event;

@end