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
- (NSArray *)entities;
- (void)addObserver:(id <ESCollectionObserver>)observer forEvent:(ESEntityChange)event;
- (void)removeObserver:(id <ESCollectionObserver>)observer forEvent:(ESEntityChange)event;
@end

@protocol ESCollectionObserver
- (void)entity:(ESChangedEntity *)changedEntity changedInCollection:(ESCollection *)collection;
@end