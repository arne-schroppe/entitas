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

- (void)activate
{
    for (NSObject <ESSystem>* system in systems)
        if ([system respondsToSelector:@selector(activate)])
            [system activate];
}

- (void)deactivate
{
    for (NSObject <ESSystem>* system in systems)
        if ([system respondsToSelector:@selector(deactivate)])
            [system deactivate];
}

- (void)removeAllSystems
{
    [systems removeAllObjects];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ %@", NSStringFromClass([self class]), [systems description]];
}

@end