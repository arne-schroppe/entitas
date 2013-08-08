#import "ESEntities.h"
#import "ESChangedEntity.h"
#import "ESComponentMatcher.h"
#import "ESAllComponentTypes.h"

@implementation ESEntities
{
    NSMutableArray *_entities;
    NSMutableDictionary *_collections;
    NSMutableDictionary *_collectionsForType;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        _entities = [NSMutableArray array];
        _collections = [NSMutableDictionary dictionary];
        _collectionsForType = [NSMutableDictionary dictionary];
    }

    return self;
}

- (ESEntity *)createEntity
{
    ESEntity *entity = [[ESEntity alloc] init];
    entity.entities = self;
    [_entities addObject:entity];
    return entity;
}

- (BOOL)containsEntity:(ESEntity *)entity
{
    return [_entities containsObject:entity];
}

- (void)destroyEntity:(ESEntity *)entity
{
    for (Class componentType in [[entity componentTypes] copy])
        [entity removeComponentOfType:componentType];

    [_entities removeObject:entity];
}

- (NSArray *)getEntitiesWithComponentsOfTypes:(NSSet *)types
{
    NSMutableArray *matchingEntities = [NSMutableArray array];
    for(ESEntity *entity in _entities)
    {
        if ([entity hasComponentsOfTypes:types])
            [matchingEntities addObject:entity];
    };

    return matchingEntities;
}

- (void)component:(NSObject <ESComponent> *)component ofType:(Class)type hasBeenAddedToEntity:(ESEntity *)entity
{
    ESChangedEntity *changedEntity = [[ESChangedEntity alloc] initWithOriginalEntity:entity components:[entity components] changeType:ESEntityAdded];
    for(ESCollection *collection in [self collectionsForType:type])
    {
        if ([[collection typeMatcher] areComponentsMatching:[entity componentTypes]])
            [collection addEntity:changedEntity];
    };
}

- (void)component:(NSObject <ESComponent> *)component ofType:(Class)type hasBeenExchangedInEntity:(ESEntity *)entity {
    ESChangedEntity *addedEntity = [[ESChangedEntity alloc] initWithOriginalEntity:entity components:[entity components] changeType:ESEntityAdded];
    ESChangedEntity *removedEntity = [[ESChangedEntity alloc] initWithOriginalEntity:entity components:[entity components] changeType:ESEntityRemoved];
    for(ESCollection *collection in [self collectionsForType:type])
    {
        if ([[collection typeMatcher] areComponentsMatching:[entity componentTypes]])
            [collection remove:removedEntity andAddEntity:addedEntity];
    };
}


- (void)component:(NSObject <ESComponent> *)component ofType:(Class)type hasBeenRemovedFromEntity:(ESEntity *)entity
{
    NSMutableDictionary *components = [[entity components] mutableCopy];
    [components setObject:component forKey:(id <NSCopying>) [component class]];
    ESChangedEntity *changedEntity = [[ESChangedEntity alloc] initWithOriginalEntity:entity components:components changeType:ESEntityRemoved];

    NSMutableSet *originalComponentTypes = [[entity componentTypes] mutableCopy];
    [originalComponentTypes addObject:type];

    for(ESCollection *collection in [self collectionsForType:type])
    {
        if ([[collection typeMatcher] areComponentsMatching:originalComponentTypes] && ![[collection typeMatcher] areComponentsMatching:[entity componentTypes]])
            [collection removeEntity:changedEntity];
    };
}

- (ESCollection *)collectionForMatcher:(NSObject <ESComponentMatcher> *)matcher {
    if (![_collections objectForKey:matcher])
    {
        ESCollection *collection = [[ESCollection alloc] initWithMatcher:matcher];

        for(ESEntity *entity in [self getEntitiesWithComponentsOfTypes:[matcher componentTypes]])
        {
            if([collection.typeMatcher areComponentsMatching:[entity componentTypes]]) {
                ESChangedEntity *changedEntity = [[ESChangedEntity alloc] initWithOriginalEntity:entity components:[entity components] changeType:ESEntityAdded];
                [collection addEntity:changedEntity];
            }
        };

        [_collections setObject:collection forKey:matcher];

        for (id type in matcher.componentTypes)
        {
            [[self collectionsForType:type] addObject:collection];
        };
    }
    return [_collections objectForKey:matcher];
}



- (ESCollection *)collectionForTypes:(NSSet *)types {
    return [self collectionForMatcher:[[ESAllComponentTypes alloc] initWithTypes:types]];
}


- (NSMutableSet *)collectionsForType:(Class)type
{
    if (![_collectionsForType objectForKey:type])
        [_collectionsForType setObject:[NSMutableSet set] forKey:(id <NSCopying>) type];

    return [_collectionsForType objectForKey:type];
}



- (NSArray *)allEntities
{
    return [_entities copy];
}

@end