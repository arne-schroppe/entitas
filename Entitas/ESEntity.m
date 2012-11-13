#import "ESEntity.h"
#import "ESComponent.h"
#import "ESEntities.h"

@implementation ESEntity {
    NSMutableSet *componentTypes;
    NSMutableDictionary *components;
}

@synthesize entities;

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
    [entities componentOfType:[component class] hasBeenAddedToEntity:self];
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
    if([self hasComponentOfType:type])
    {
        [components removeObjectForKey:type];
        [componentTypes removeObject:type];
        [entities componentOfType:type hasBeenRemovedFromEntity:self];
    }
}

- (NSObject <ESComponent> *)getComponentOfType:(Class)type
{
    return [components objectForKey:type];
}

- (BOOL)hasComponentsOfTypes:(NSSet *)types
{
    return [types isSubsetOfSet:componentTypes];
}

- (NSSet *)componentTypes
{
 return componentTypes;
}
@end