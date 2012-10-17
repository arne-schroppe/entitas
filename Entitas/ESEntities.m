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
@end