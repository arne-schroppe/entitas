#import "ESEntities.h"
#import "ESEntity.h"


@implementation ESEntities {
    NSMutableArray *entities;
}

- (id)init
{
    self = [super init];
    if (self) {
        entities = [NSMutableArray array];
    }

    return self;
}


- (ESEntity *)createEntity
{
    ESEntity *entity = [[ESEntity alloc] init];
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
@end