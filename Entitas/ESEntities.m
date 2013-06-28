#import "ESEntities.h"
#import "ESChangedEntity.h"

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
        if ([[collection types] isSubsetOfSet:[entity componentTypes]])
            [collection addEntity:changedEntity];
    };
}

- (void)component:(NSObject <ESComponent> *)component ofType:(Class)type hasBeenExchangedInEntity:(ESEntity *)entity {
    ESChangedEntity *addedEntity = [[ESChangedEntity alloc] initWithOriginalEntity:entity components:[entity components] changeType:ESEntityAdded];
    ESChangedEntity *removedEntity = [[ESChangedEntity alloc] initWithOriginalEntity:entity components:[entity components] changeType:ESEntityRemoved];
    for(ESCollection *collection in [self collectionsForType:type])
    {
        if ([[collection types] isSubsetOfSet:[entity componentTypes]])
            [collection remove:removedEntity andAddEntity:addedEntity];
    };
}


- (void)component:(NSObject <ESComponent> *)component ofType:(Class)type hasBeenRemovedFromEntity:(ESEntity *)entity
{
    NSMutableDictionary *components = [[entity components] mutableCopy];
    [components setObject:component forKey:[component class]];
    ESChangedEntity *changedEntity = [[ESChangedEntity alloc] initWithOriginalEntity:entity components:components changeType:ESEntityRemoved];

    NSMutableSet *originalComponentTypes = [[entity componentTypes] mutableCopy];
    [originalComponentTypes addObject:type];

    for(ESCollection *collection in [self collectionsForType:type])
    {
        if ([[collection types] isSubsetOfSet:originalComponentTypes] && ![[collection types] isSubsetOfSet:[entity componentTypes]])
            [collection removeEntity:changedEntity];
    };
}

- (ESCollection *)collectionForTypes:(NSSet *)types
{
    if (types.count < 1)
        [NSException raise:@"Empty type set." format:@"A collection for an empty type-set cannot be provided."];
    if (![_collections objectForKey:types])
    {
        ESCollection *collection = [[ESCollection alloc] initWithTypes:types];

        for(ESEntity *entity in [self getEntitiesWithComponentsOfTypes:types])
        {
            ESChangedEntity *changedEntity = [[ESChangedEntity alloc] initWithOriginalEntity:entity components:[entity components] changeType:ESEntityAdded];
            [collection addEntity:changedEntity];
        };

        [_collections setObject:collection forKey:types];

        for (id type in types)
        {
            [[self collectionsForType:type] addObject:collection];
        };
    }
    return [_collections objectForKey:types];
}

- (NSMutableSet *)collectionsForType:(Class)type
{
    if (![_collectionsForType objectForKey:type])
        [_collectionsForType setObject:[NSMutableSet set] forKey:type];

    return [_collectionsForType objectForKey:type];
}

- (NSArray *)allEntities
{
    return [_entities copy];
}

@end