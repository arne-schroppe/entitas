#import "ESChangedEntity.h"

@implementation ESChangedEntity
{
    ESEntity *_originalEntity;
    NSArray *_changedComponents;
}

- (id)initWithOriginalEntity:(ESEntity *)originalEntity ChangedComponents:(NSArray *)changedComponents
{
    self = [super init];
    if (self)
    {
        _originalEntity = originalEntity;
        _changedComponents = changedComponents;
    }

    return self;
}

- (ESEntity *)getOriginalEntity
{
    return _originalEntity;
}

- (NSObject <ESComponent> *)getComponentOfType:(Class)type
{
    for (NSObject <ESComponent>*component in _changedComponents)
        if ([component class] == type)
            return component;
    return [_originalEntity getComponentOfType:type];
}
@end