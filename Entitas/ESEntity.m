#import "ESEntity.h"
#import "ESEntities.h"

@implementation ESEntity
{
    NSMutableSet *_componentTypes;
    NSMutableDictionary *_components;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        _components = [NSMutableDictionary dictionary];
        _componentTypes = [NSMutableSet set];
    }

    return self;
}

- (void)addComponent:(NSObject <ESComponent> *)component
{
    if ([self hasComponentOfType:[component class]])
        [NSException raise:@"An entity cannot contain multiple components of the same type." format:@""];

    [_componentTypes addObject:[component class]];
    [_components setObject:component forKey:(id <NSCopying>) [component class]];
    [_entities component:component ofType:[component class] hasBeenAddedToEntity:self];
}


- (void)exchangeComponent:(NSObject <ESComponent> *)component {
    [_componentTypes addObject:[component class]];
    [_components setObject:component forKey:(id <NSCopying>) [component class]];
    [_entities component:component ofType:[component class] hasBeenExchangedInEntity:self];
}


- (BOOL)containsComponent:(NSObject <ESComponent> *)component
{
    return [_components objectForKey:[component class]] != nil;
}

- (BOOL)hasComponentOfType:(Class)type
{
    return [_componentTypes containsObject:type];
}

- (void)removeComponentOfType:(Class)type
{
    if ([self hasComponentOfType:type])
    {
        NSObject <ESComponent> *component = [_components objectForKey:type];
        [_components removeObjectForKey:type];
        [_componentTypes removeObject:type];
        [_entities component:component ofType:type hasBeenRemovedFromEntity:self];
    }
}

- (NSObject <ESComponent> *)componentOfType:(Class)type
{
    return [_components objectForKey:type];
}

- (BOOL)hasComponentsOfTypes:(NSSet *)types
{
    return [types isSubsetOfSet:_componentTypes];
}

- (NSSet *)componentTypes
{
    return _componentTypes;
}

- (NSDictionary *)components
{
    return _components;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"[%@ %@]", NSStringFromClass([self class]), [_components description]];
}

@end