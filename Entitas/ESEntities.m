#import "ESEntities.h"
#import "ESEntity.h"
#import "ESCollection.h"


@implementation ESEntities {
    NSMutableArray *entities;
    NSMutableDictionary *collections;
}

- (id)init
{
    self = [super init];
    if (self) {
        entities = [NSMutableArray array];
        collections = [NSMutableDictionary dictionary];
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
    [collections enumerateKeysAndObjectsUsingBlock:^(NSSet *set, ESCollection *collection, BOOL *stop) {
        if ([set isSubsetOfSet:[entity set]])
            [collection addEntity:entity];
    }];
}

- (void)componentOfType:(Class)type hasBeenRemovedFromEntity:(ESEntity *)entity
{
    [collections enumerateKeysAndObjectsUsingBlock:^(NSSet *set, ESCollection *collection, BOOL *stop) {
        if (![set isSubsetOfSet:[entity set]])
            [collection removeEntity:entity];
    }];
}

- (ESCollection *)getCollection:(NSSet *)types
{
    if (![collections objectForKey:types])
    {
        ESCollection *collection = [[ESCollection alloc] initWithTypes:types];
        [[self getEntitiesWithComponentsOfTypes:types] enumerateObjectsUsingBlock:^(ESEntity *entity, NSUInteger idx, BOOL *stop) {
            [collection addEntity:entity];
        }];
        [collections setObject:collection forKey:types];
    }
    return [collections objectForKey:types];
}
@end