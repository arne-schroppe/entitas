#import "ESCollection.h"
#import "ESEntity.h"


@implementation ESCollection {
    NSSet *types_;
    NSMutableSet *entities_;
}

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
}

- (NSSet *)entities
{
    return [NSSet setWithSet:entities_];
}

- (void)removeEntity:(ESEntity *)entity
{
    [entities_ removeObject:entity];
}
@end