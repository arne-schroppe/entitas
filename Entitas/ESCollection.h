#import <Foundation/Foundation.h>
#import "ESEntity.h"

@class ESChangedEntity;
@protocol ESCollectionObserver;

typedef NS_ENUM(NSUInteger, ESEntityChange)
{
    ESEntityAdded,
    ESEntityRemoved
};

@interface ESCollection : NSObject
- (id)initWithTypes:(NSSet *)types;

- (NSSet *)types;

- (void)addEntity:(ESChangedEntity *)changedEntity;

- (NSOrderedSet *)entities;

- (void)removeEntity:(ESChangedEntity *)changedEntity;

- (void)addObserver:(id <ESCollectionObserver>)observer forEvent:(ESEntityChange)event;

- (void)removeObserver:(id <ESCollectionObserver>)observer forEvent:(ESEntityChange)event;

- (void)remove:(ESChangedEntity *)removedEntity andAddEntity:(ESChangedEntity *)addedEntity;
@end


@protocol ESCollectionObserver

- (void)entity:(ESChangedEntity *)changedEntity changedInCollection:(ESCollection *)collection;

@end