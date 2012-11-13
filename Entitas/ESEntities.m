#import "ESEntities.h"
#import "ESEntity.h"
#import "ESCollection.h"


@interface ESEntities ()
- (NSArray *)getEntitiesWithComponentsOfTypes:(NSSet *)types;

- (NSMutableSet *)getCollectionsForType:(Class)type;

@end

@implementation ESEntities {
    NSMutableArray *entities;
    NSMutableDictionary *collections;
    NSMutableDictionary *collectionsForType;
}

- (id)init
{
    self = [super init];
    if (self) {
        entities = [NSMutableArray array];
        collections = [NSMutableDictionary dictionary];
        collectionsForType = [NSMutableDictionary dictionary];
    }

    return self;
}


- (ESEntity *)createEntity
{
    ESEntity *entity = [[ESEntity alloc] init];
    entity.entities = self;
    [entities addObject:entity];
    return entity;
}

- (BOOL)containsEntity:(ESEntity *)entity
{
    return [entities containsObject:entity];
}

- (void)destroyEntity:(ESEntity *)entity
{
    [entities removeObject:entity];
}

- (NSArray *)getEntitiesWithComponentsOfTypes:(NSSet *)types
{
    NSMutableArray *matchingEntities = [NSMutableArray array];
    [entities enumerateObjectsUsingBlock:^(ESEntity *entity, NSUInteger idx, BOOL *stop) {
        if ([entity hasComponentsOfTypes:types])
            [matchingEntities addObject:entity];
    }];
    return matchingEntities;
}

- (void)componentOfType:(Class)type hasBeenAddedToEntity:(ESEntity *)entity
{
    [[self getCollectionsForType:type] enumerateObjectsUsingBlock:^(ESCollection *collection, BOOL *stop) {
        if ([[collection types] isSubsetOfSet:[entity set]])
            [collection addEntity:entity];
    }];
}

- (void)componentOfType:(Class)type hasBeenRemovedFromEntity:(ESEntity *)entity
{
    [[self getCollectionsForType:type] enumerateObjectsUsingBlock:^(ESCollection *collection, BOOL *stop) {
        if (![[collection types] isSubsetOfSet:[entity set]])
            [collection removeEntity:entity];
    }];
}

- (ESCollection *)getCollectionForTypes:(NSSet *)types
{
    if (![collections objectForKey:types])
    {
        ESCollection *collection = [[ESCollection alloc] initWithTypes:types];
        [[self getEntitiesWithComponentsOfTypes:types] enumerateObjectsUsingBlock:^(ESEntity *entity, NSUInteger idx, BOOL *stop) {
            [collection addEntity:entity];
        }];

        [collections setObject:collection forKey:types];

        [types enumerateObjectsUsingBlock:^(id type, BOOL *stop_types) {
            [[self getCollectionsForType:type] addObject:collection];
        }];
    }
    return [collections objectForKey:types];
}

- (NSMutableSet *)getCollectionsForType:(Class)type
{
    if (![collectionsForType objectForKey:type])
        [collectionsForType setObject:[NSMutableSet set] forKey:type];
    return [collectionsForType objectForKey:type];
}
@end