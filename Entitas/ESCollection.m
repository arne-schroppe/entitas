#import "ESCollection.h"
#import "ESChangedEntity.h"
#import "ESComponentMatcher.h"
#import "ESAnyComponentType.h"
#import "ESAllComponentTypes.h"

@implementation ESCollection
{
    NSObject<ESComponentMatcher> *_typeMatcher;
    NSMutableArray *_entities;
    NSMutableArray *_addObservers;
    NSMutableArray *_removeObservers;
}


- (id)initWithTypes:(NSSet *)types
{
    return [self initWithMatcher:[[ESAllComponentTypes alloc] initWithTypes:types] ];
}



- (id)initWithMatcher:(NSObject<ESComponentMatcher> *)types
{
    self = [super init];
    if (self)
    {
        _typeMatcher = types;
        _entities = [NSMutableArray array];
        _addObservers = [NSMutableArray array];
        _removeObservers = [NSMutableArray array];
    }

    return self;
}

- (NSObject<ESComponentMatcher> *)typeMatcher
{
    return _typeMatcher;
}

- (void)addEntity:(ESChangedEntity *)changedEntity {

    if(![_entities containsObject:changedEntity.originalEntity]){
        [_entities addObject:changedEntity.originalEntity];
    }

    for (id<ESCollectionObserver> observer in _addObservers){
        [observer entity:changedEntity changedInCollection:self];
    }
}

- (void)remove:(ESChangedEntity *)removedEntity andAddEntity:(ESChangedEntity *)addedEntity {

    if([_entities containsObject:removedEntity.originalEntity]){
        for (id<ESCollectionObserver> observer in _removeObservers){
            [observer entity:removedEntity changedInCollection:self];
        }
    }

    [self addEntity:addedEntity];
}

- (NSArray *)entities
{
    return [_entities copy];
}

- (void)removeEntity:(ESChangedEntity *)changedEntity {
    [_entities removeObject:changedEntity.originalEntity];
    for (id<ESCollectionObserver> observer in _removeObservers){
        [observer entity:changedEntity changedInCollection:self];
    }
}

- (void)addObserver:(id <ESCollectionObserver>)observer forEvent:(ESEntityChange)event {
    if(event == ESEntityAdded){
        if(![_addObservers containsObject:observer]) {
            [_addObservers addObject:observer];
        }
    } else if (event == ESEntityRemoved) {
        if(![_removeObservers containsObject:observer]) {
            [_removeObservers addObject:observer];
        }
    }
}

- (void)removeObserver:(id <ESCollectionObserver>)observer forEvent:(ESEntityChange)event {
    if(event == ESEntityAdded){
        [_addObservers removeObject:observer];
    } else if (event == ESEntityRemoved) {
        [_removeObservers removeObject:observer];
    }
}

@end