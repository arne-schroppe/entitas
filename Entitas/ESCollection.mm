#import "ESCollection.h"
#import "ESChangedEntity.h"
#import "ESMatcher.h"
#import "AvlNode.h"
#import <map>

@implementation ESCollection
{
	ESMatcher *_typeMatcher;
    std::map<id, u_long> _lookup;
    AvlNode *_entities;
    u_long _index;
    NSMutableArray *_addObservers;
    NSMutableArray *_removeObservers;
    EqualityComparer _comparer;
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
        std::map<id, u_long> weakLookup = _lookup;
        _comparer =^int(id v1, id v2) {
            if(_lookup[v1] > _lookup[v2]){
                return -1;
            } else if (_lookup[v1] < _lookup[v2]) {
                return 1;
            }
            return 0;
        };
        _entities = [AvlNode emptyWithComparer:_comparer];

        _addObservers = [NSMutableArray array];
        _removeObservers = [NSMutableArray array];
        _index = 0;
    }

    return self;
}

- (ESMatcher *)typeMatcher
{
    return _typeMatcher;
}

- (void)addEntity:(ESChangedEntity *)changedEntity {
    
    ESEntity *entity = changedEntity.originalEntity;
    
    std::map<id,u_long>::iterator it= _lookup.find(entity);

    if(it == _lookup.end()){
        _lookup.insert(std::pair<id,int>(entity,_index));
        _entities = [_entities newWithValue:entity];
        _index++;
    }

    for (id<ESCollectionObserver> observer in _addObservers){
        [observer entity:changedEntity changedInCollection:self];
    }
}

- (void)remove:(ESChangedEntity *)removedEntity andAddEntity:(ESChangedEntity *)addedEntity
{

    std::map<id,u_long>::iterator it= _lookup.find(removedEntity.originalEntity);
    
    if(it != _lookup.end()){
        for (id<ESCollectionObserver> observer in _removeObservers){
            [observer entity:removedEntity changedInCollection:self];
        }
    }

    [self addEntity:addedEntity];
}

- (NSArray *)entities
{
    return _entities.enumerator.allObjects;
}

- (void)removeEntity:(ESChangedEntity *)changedEntity {
    
    ESEntity *entity = changedEntity.originalEntity;
    
    std::map<id,u_long>::iterator it= _lookup.find(entity);
    if(it == _lookup.end()){
        return;
    }
    
    _lookup.erase(it);
    _entities = [_entities newWithoutValue:entity];
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