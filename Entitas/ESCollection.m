#import "ESCollection.h"
#import "ESChangedEntity.h"

@implementation ESCollection
{
    NSSet *_types;
    NSMutableSet *_entities;
    NSMutableSet *_addObservers;
    NSMutableSet *_removeObservers;
}


- (id)initWithTypes:(NSSet *)types
{
    self = [super init];
    if (self)
    {
        _types = types;
        _entities = [[NSMutableSet alloc] init];
        _addObservers = [NSMutableSet set];
        _removeObservers = [NSMutableSet set];
    }

    return self;
}

- (NSSet *)types
{
    return _types;
}

- (void)addEntity:(ESChangedEntity *)changedEntity {
    [_entities addObject:changedEntity.originalEntity];
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

- (NSSet *)entities
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
        [_addObservers addObject:observer];
    } else if (event == ESEntityRemoved) {
        [_removeObservers addObject:observer];
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