#import "ESCollection.h"
#import "ESChangedEntity.h"
#import "ESMatcher.h"
#import "AvlNode.h"
#import <unordered_map>

@implementation ESCollection
{
	ESMatcher *_typeMatcher;
    std::unordered_map<void*, u_long> _lookup;
    AvlNode *_entities;
    u_long _index;
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
    
    void* bridgedEntity = (__bridge void*)entity;
    
    std::unordered_map<void*,u_long>::iterator it= _lookup.find(bridgedEntity);

    if(it == _lookup.end()){
        _lookup.insert(std::pair<void*,int>(bridgedEntity,_index));
        if(!_entities){
            _entities = [[AvlNode alloc] initWithValue:entity andIndex:_index];
        } else {
            _entities = [_entities newWithValue:entity andIndex:_index];
        }
        
        _index++;
    }

    for (id<ESCollectionObserver> observer in _addObservers){
        [observer entity:changedEntity changedInCollection:self];
    }
}

- (void)remove:(ESChangedEntity *)removedEntity andAddEntity:(ESChangedEntity *)addedEntity
{

    void* bridgedEntity = (__bridge void*)removedEntity.originalEntity;
    std::unordered_map<void*,u_long>::iterator it= _lookup.find(bridgedEntity);
    
    if(it != _lookup.end()){
        for (id<ESCollectionObserver> observer in _removeObservers){
            [observer entity:removedEntity changedInCollection:self];
        }
    }

    [self addEntity:addedEntity];
}

- (NSArray *)entities
{
    if(!_entities){
        return @[];
    }
    return _entities.allObjects;
}

- (void)removeEntity:(ESChangedEntity *)changedEntity {
    
    ESEntity *entity = changedEntity.originalEntity;
    
    void* bridgedEntity = (__bridge void*)entity;
    
    std::unordered_map<void*,u_long>::iterator it= _lookup.find(bridgedEntity);
    if(it == _lookup.end()){
        return;
    }
    
    _entities = [_entities newWithoutValueOnIndex:it->second];
    _lookup.erase(it);
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