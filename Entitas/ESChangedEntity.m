#import "ESChangedEntity.h"

@implementation ESChangedEntity
{
    ESEntity *_originalEntity;
    NSDictionary *_components;
    ESEntityChange _changeType;
}

- (id)initWithOriginalEntity:(ESEntity *)originalEntity Components:(NSDictionary *)components ChangeType:(ESEntityChange)changeType {
    self = [super init];
    if (self)
    {
        _originalEntity = originalEntity;
        _components = components;
        _changeType = changeType;
    }

    return self;
}

- (ESEntity *)getOriginalEntity
{
    return _originalEntity;
}

- (NSObject <ESComponent> *)getComponentOfType:(Class)type
{
    return [_components objectForKey:type];
}

- (ESEntityChange)changeType 
{
    return _changeType;
}
@end