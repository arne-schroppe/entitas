#import "ESEntity.h"
#import "ESComponent.h"

@implementation ESEntity {
    NSMutableSet *componentTypes;
    NSMutableDictionary *components;
}

- (id)init {
    self = [super init];
    if (self) {
        components = [NSMutableDictionary dictionary];
        componentTypes = [NSMutableSet set];
    }

    return self;
}

- (void)addComponent:(NSObject <ESComponent> *)component
{
    if ([self hasComponentOfType:[component class]])
        [NSException raise:@"An entity cannot contain multiple components of the same type." format:@""];

    [componentTypes addObject:[component class]];
    [components setObject:component forKey:[component class]];
}

- (BOOL)containsComponent:(NSObject <ESComponent> *)component
{
    return !![components objectForKey:[component class]];
}

- (BOOL)hasComponentOfType:(Class)type
{
    return [componentTypes containsObject:type];
}

- (void)removeComponentOfType:(Class)type
{
    [components removeObjectForKey:type];
    [componentTypes removeObject:type];
}

- (NSObject <ESComponent> *)getComponentOfType:(Class)type
{
    return [components objectForKey:type];
}

- (BOOL)hasComponentsOfTypes:(NSSet *)types
{
    return [types isSubsetOfSet:componentTypes];
}
@end