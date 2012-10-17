#import "ESEntity.h"
#import "ESComponent.h"

@implementation ESEntity {
    NSMutableArray *components;
}

- (id)init {
    self = [super init];
    if (self) {
        components = [NSMutableArray array];
    }

    return self;
}

- (void)addComponent:(NSObject <ESComponent> *)component
{
    if ([self hasComponentOfType:[component class]])
        [NSException raise:@"An entity cannot contain multiple components of the same type." format:@""];
    [components addObject:component];
}

- (BOOL)containsComponent:(NSObject <ESComponent> *)component
{
    return [components containsObject:component];
}

- (BOOL)hasComponentOfType:(Class)type
{
    for (NSObject <ESComponent>*component in components)
        if( [component class] == type )
            return YES;
    return NO;
}

- (void)removeComponentOfType:(Class)type
{
    NSObject <ESComponent>*componentToRemove = nil;
    for (NSObject <ESComponent>*component in components)
        if( [component class] == type )
            componentToRemove = component;
    if(!!componentToRemove)
        [components removeObject:componentToRemove];
}

- (NSObject <ESComponent> *)getComponentOfType:(Class)type
{
    NSObject <ESComponent>*componentOfType = nil;
    for (NSObject <ESComponent>*component in components)
        if( [component class] == type )
            componentOfType = component;
    return componentOfType;
}

- (BOOL)hasComponentsOfTypes:(NSArray *)types
{
    for (Class type in types)
        if (![self hasComponentOfType:type])
            return NO;
    return YES;
}
@end