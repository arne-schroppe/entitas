#import "ESCollection.h"
#import "ESChangedEntity.h"

@implementation ESCollection {
    NSSet *_types;
    NSMutableSet *_entities;
}

NSString *const ESEntityAdded = @"ESEntityAdded";
NSString *const ESEntityRemoved = @"ESEntityRemoved";

- (id)initWithTypes:(NSSet *)types {
    self = [super init];
    if (self) {
        _types = types;
        _entities = [[NSMutableSet alloc] init];
    }

    return self;
}

- (NSSet *)types {
    return _types;
}

- (void)addEntity:(ESEntity *)entity {
    [_entities addObject:entity];
    ESChangedEntity *changedEntity = [[ESChangedEntity alloc] initWithOriginalEntity:entity components:[entity components] changeType:ESEntityAddedToCollection];
    [[NSNotificationCenter defaultCenter] postNotificationName:ESEntityAdded object:self userInfo:[NSDictionary dictionaryWithObject:changedEntity forKey:[ESChangedEntity class]]];
}

- (NSSet *)entities {
    return [_entities copy];
}

- (void)removeEntity:(ESEntity *)entity becauseOfRemovedComponent:(NSObject <ESComponent> *)removedComponent {
    [_entities removeObject:entity];
    NSMutableDictionary *components = [[entity components] mutableCopy];
    [components setObject:removedComponent forKey:[removedComponent class]];
    ESChangedEntity *changedEntity = [[ESChangedEntity alloc] initWithOriginalEntity:entity components:components changeType:ESEntityRemovedFromCollection];
    [[NSNotificationCenter defaultCenter] postNotificationName:ESEntityRemoved object:self userInfo:[NSDictionary dictionaryWithObject:changedEntity forKey:[ESChangedEntity class]]];
}

@end