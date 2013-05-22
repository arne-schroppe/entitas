#import "ESCollection.h"
#import "ESChangedEntity.h"

@implementation ESCollection
{
    NSSet *_types;
    NSMutableSet *_entities;
}

NSString *const ESEntityAdded = @"ESEntityAdded";
NSString *const ESEntityRemoved = @"ESEntityRemoved";

- (id)initWithTypes:(NSSet *)types
{
    self = [super init];
    if (self)
    {
        _types = types;
        _entities = [[NSMutableSet alloc] init];
    }

    return self;
}

- (NSSet *)types
{
    return _types;
}

- (void)addEntity:(ESChangedEntity *)changedEntity {
    [_entities addObject:changedEntity.originalEntity];
    [[NSNotificationCenter defaultCenter] postNotificationName:ESEntityAdded object:self userInfo:[NSDictionary dictionaryWithObject:changedEntity forKey:[ESChangedEntity class]]];
}

- (NSSet *)entities
{
    return [_entities copy];
}

- (void)removeEntity:(ESChangedEntity *)changedEntity {
    [_entities removeObject:changedEntity.originalEntity];
    [[NSNotificationCenter defaultCenter] postNotificationName:ESEntityRemoved object:self userInfo:[NSDictionary dictionaryWithObject:changedEntity forKey:[ESChangedEntity class]]];
}

@end