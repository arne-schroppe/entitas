#import "ESEntity.h"

@class ESMatcher;

@protocol ESCollectionObserver

- (void)entity:(ESEntity *)changedEntity changedInCollection:(ESCollection *)collection withChangeType:(ESEntityChange)changeType;

@end

typedef NS_ENUM(NSUInteger, ESEntityChange)
{
    ESEntityAdded,
    ESEntityRemoved
};

@interface ESCollection : NSObject

- (id)initWithTypes:(NSSet *)types;

- (id)initWithMatcher:(ESMatcher *)matcher;

- (ESMatcher *)typeMatcher;

- (void)addEntity:(ESEntity *)changedEntity;

- (void)removeEntity:(ESEntity *)entity;

- (void)exchangeEntity:(ESEntity *)entity;

- (void)addObserver:(id <ESCollectionObserver>)observer forEvent:(ESEntityChange)event;

- (void)removeObserver:(id <ESCollectionObserver>)observer forEvent:(ESEntityChange)event;

- (NSArray *)entities;

@end