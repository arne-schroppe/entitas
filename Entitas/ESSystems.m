#import "ESSystems.h"

@implementation ESSystems {
    NSMutableArray *systems;
}

- (id)init {
    self = [super init];
    if (self) {
        systems = [NSMutableArray array];
    }

    return self;
}

- (void)addSystem:(NSObject <ESSystem> *)system
{
    [systems addObject:system];
}

- (BOOL)containsSystem:(NSObject <ESSystem> *)system
{
    return [systems containsObject:system];
}

- (void)removeSystem:(NSObject <ESSystem> *)system
{
    [systems removeObject:system];
}

- (void)execute
{
    for (NSObject <ESSystem>* system in systems)
        [system execute];
}
@end