#import "ESCollection.h"
#import "ESEntity.h"


@implementation ESCollection {
    NSSet *set_;
    NSMutableArray *entities_;
}

- (id)initWithSet:(NSSet *)set
{
    self = [super init];
    if (self) {
        set_ = set;
        entities_ = [[NSMutableArray alloc] init];
    }

    return self;
}

- (NSSet *)set
{
    return set_;
}

- (void)addEntity:(ESEntity *)entity
{
    [entities_ addObject:entity];
}

- (NSArray *)entities
{
    return entities_;
}

- (void)removeEntity:(ESEntity *)entity
{
    [entities_ removeObject:entity];
}
@end