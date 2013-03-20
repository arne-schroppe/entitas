#import "ESEntities.h"

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
    [_entities enumerateObjectsUsingBlock:^(ESEntity *entity, NSUInteger idx, BOOL *stop)
    {
        if ([entity hasComponentsOfTypes:types])
            [matchingEntities addObject:entity];
    }];

    return matchingEntities;
}

- (void)component:(NSObject <ESComponent> *)component ofType:(Class)type hasBeenAddedToEntity:(ESEntity *)entity
{
    [[self collectionsForType:type] enumerateObjectsUsingBlock:^(ESCollection *collection, BOOL *stop)
    {
        if ([[collection types] isSubsetOfSet:[entity componentTypes]])
            [collection addEntity:entity];
    }];
}

- (void)component:(NSObject <ESComponent> *)component ofType:(Class)type hasBeenRemovedFromEntity:(ESEntity *)entity
{
    [[self collectionsForType:type] enumerateObjectsUsingBlock:^(ESCollection *collection, BOOL *stop)
    {
        if (![[collection types] isSubsetOfSet:[entity componentTypes]])
            [collection removeEntity:entity becauseOfRemovedComponent:component];
    }];
}

- (ESCollection *)collectionForTypes:(NSSet *)types
{
    if (types.count < 1)
        [NSException raise:@"Empty type set." format:@"A collection for an empty type-set cannot be provided."];
    if (![_collections objectForKey:types])
    {
        ESCollection *collection = [[ESCollection alloc] initWithTypes:types];
        [[self getEntitiesWithComponentsOfTypes:types] enumerateObjectsUsingBlock:^(ESEntity *entity, NSUInteger idx, BOOL *stop)
        {
            [collection addEntity:entity];
        }];

        [_collections setObject:collection forKey:types];

        [types enumerateObjectsUsingBlock:^(id type, BOOL *stop_types)
        {
            [[self collectionsForType:type] addObject:collection];
        }];
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