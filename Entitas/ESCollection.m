#import "ESCollection.h"
#import "ESEntity.h"
#import "ESChangedEntity.h"

@implementation ESCollection {
    NSSet *types_;
    NSMutableSet *entities_;
}

extern  NSString * const ESEntityAdded = @"ESEntityAdded";
extern  NSString * const ESEntityRemoved = @"ESEntityRemoved";

- (id)initWithTypes:(NSSet *)types
{
    self = [super init];
    if (self) {
        types_ = types;
        entities_ = [[NSMutableSet alloc] init];
    }

    return self;
}

- (NSSet *)types
{
    return types_;
}

- (void)addEntity:(ESEntity *)entity
{
    [entities_ addObject:entity];
    ESChangedEntity *changedEntity = [[ESChangedEntity alloc] initWithOriginalEntity:entity Components:[entity components] ChangeType:ESEntityAddedToCollection];
    [[NSNotificationCenter defaultCenter] postNotificationName:ESEntityAdded object:self userInfo:[NSDictionary dictionaryWithObject:changedEntity forKey:[ESChangedEntity class]]];
}

- (NSSet *)entities
{
    return [NSSet setWithSet:entities_];
}

- (void)removeEntity:(ESEntity *)entity becauseOfRemovedComponent:(NSObject <ESComponent> *)removedComponent
{
    [entities_ removeObject:entity];
    NSMutableDictionary *components = [NSMutableDictionary dictionaryWithDictionary:[entity components]];
    [components setObject:removedComponent forKey:[removedComponent class]];
    ESChangedEntity *changedEntity = [[ESChangedEntity alloc] initWithOriginalEntity:entity Components:components ChangeType:ESEntityRemovedFromCollection];
    [[NSNotificationCenter defaultCenter] postNotificationName:ESEntityRemoved object:self userInfo:[NSDictionary dictionaryWithObject:changedEntity forKey:[ESChangedEntity class]]];
}
@end