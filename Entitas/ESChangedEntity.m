#import "ESChangedEntity.h"
#import "ESCollection.h"

@implementation ESChangedEntity
{
    ESEntity *_originalEntity;
    NSDictionary *_components;
    ESEntityChange _changeType;
}

- (id)initWithOriginalEntity:(ESEntity *)originalEntity components:(NSDictionary *)components changeType:(ESEntityChange)changeType
{
    self = [super init];
    if (self)
    {
        _originalEntity = originalEntity;
        _components = components;
        _changeType = changeType;
    }

    return self;
}

- (ESEntity *)originalEntity
{
    return _originalEntity;
}

- (NSObject <ESComponent> *)componentOfType:(Class)type
{
    return [_components objectForKey:type];
}

- (ESEntityChange)changeType
{
    return _changeType;
}

@end