#import "ESCollection.h"
#import "ESChangedEntity.h"
#import <map>

@implementation ESCollection
{
    ESMatcher *_typeMatcher;
    std::map<u_long, id> _entities;
    NSMutableArray *_addObservers;
    NSMutableArray *_removeObservers;
}


- (id)initWithTypes:(NSSet *)types
{
    return [self initWithMatcher:[ESMatcher allOfSet:types] ];
}

- (id)initWithMatcher:(ESMatcher *)types
{
    self = [super init];
    if (self)
    {
        _typeMatcher = types;

        _addObservers = [NSMutableArray array];
        _removeObservers = [NSMutableArray array];
    }

    return self;
}

- (ESMatcher *)typeMatcher
{
    return _typeMatcher;
}

- (void)addEntity:(ESChangedEntity *)changedEntity {

    ESEntity *entity = changedEntity.originalEntity;

    std::map<u_long, id>::iterator it= _entities.find(entity.creationIndex);

    if(it == _entities.end()){
        _entities.insert(std::pair<u_long, id>(entity.creationIndex, entity));
    }

    for (id<ESCollectionObserver> observer in _addObservers){
        [observer entity:changedEntity changedInCollection:self];
    }
}

- (void)remove:(ESChangedEntity *)removedEntity andAddEntity:(ESChangedEntity *)addedEntity
{


    std::map<u_long, id>::iterator it= _entities.find(removedEntity.originalEntity.creationIndex);
    if(it != _entities.end()){
        for (id<ESCollectionObserver> observer in _removeObservers){
            [observer entity:removedEntity changedInCollection:self];
        }
    }

    [self addEntity:addedEntity];
}

- (NSArray *)entities
{
    NSMutableArray *result = [NSMutableArray new];
    for (std::map<u_long, id>::iterator it= _entities.begin(); it!= _entities.end(); ++it){
        [result addObject:it->second];
    }

    return result;
}

- (void)removeEntity:(ESChangedEntity *)changedEntity {

    ESEntity *entity = changedEntity.originalEntity;

    std::map<u_long, id>::iterator it= _entities.find(entity.creationIndex);
    if(it == _entities.end()){
        return;
    }

    _entities.erase(it);
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