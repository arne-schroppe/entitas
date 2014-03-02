#import "ESMatcher.h"
#import "ESSystem.h"
#import "ESEntityRepository.h"
#import "ESReactiveSystem.h"
#import "ESReactiveSubSystem.h"
#import "ESEntityRepository+Internal.h"


@interface ESReactiveSystem (CollectionObserver) <ESCollectionObserver>

@end


@implementation ESReactiveSystem {
    ESEntityRepository *_entityRepository;

    ESCollection *_watcherCollection;
    NSMutableArray *_collectedEntities;

    BOOL _isActive;
    ESMatcher *_mandatoryComponents;
}


- (void)dealloc {
    [_watcherCollection removeObserver:self forEvent:_notificationType];
}


- (id)initWithSystem:(NSObject <ESReactiveSubSystem> *)system entityRepository:(ESEntityRepository *)entityRepository notificationType:(ESEntityChange)type {
    NSAssert(system, @"Needs a system");

    self = [super init];
    if (self) {

        _entityRepository = entityRepository;
        _clientSystem = system;
        _notificationType = type;
        _collectedEntities = [[NSMutableArray alloc] init];

        ESMatcher *triggeringMatcher = _clientSystem.triggeringComponents;
        _watcherCollection = [_entityRepository collectionForMatcher:triggeringMatcher];

        _mandatoryComponents = [ESMatcher allOf:nil]; //allow everything by default
        if ([_clientSystem respondsToSelector:@selector(mandatoryComponents)]) {
            ESMatcher * mandatoryComponents = _clientSystem.mandatoryComponents;
            _mandatoryComponents = mandatoryComponents;
        }

        [self activate];
    }

    return self;
}


- (void)execute {

    if (_collectedEntities.count == 0) {
        return;
    }

	NSMutableArray *entitiesForCurrentExecution = [[NSMutableArray alloc] init];
	for (ESEntity *entity in _collectedEntities) {
		if ([_mandatoryComponents areComponentsMatching:entity.componentTypes]) {
			[entitiesForCurrentExecution addObject:entity];
		}
	}

    _collectedEntities = [[NSMutableArray alloc] init];

    if (entitiesForCurrentExecution.count == 0) {
        return;
    }

    [_clientSystem executeWithEntities:[entitiesForCurrentExecution copy]];
}


- (void)activate {
    [self deactivate];
    [_watcherCollection addObserver:self forEvent:_notificationType];
    _isActive = YES;
}


- (void)deactivate {
    [_watcherCollection removeObserver:self forEvent:_notificationType];
    [_collectedEntities removeAllObjects];
    _isActive = NO;
}


- (NSString *)description {
    NSString *activated = _isActive ? @"active" : @"inactive";

    ESMatcher *triggeringTypes = [_clientSystem triggeringComponents];
    NSMutableArray *triggeringTypeClassNames = [NSMutableArray arrayWithCapacity:triggeringTypes.componentTypes.count];
    for (Class type in triggeringTypes.componentTypes) {
        [triggeringTypeClassNames addObject:NSStringFromClass(type)];
    }

	ESMatcher *mandatoryTypes = [_clientSystem mandatoryComponents];
    NSMutableArray *mandatoryTypeClassNames = [NSMutableArray arrayWithCapacity:mandatoryTypes.componentTypes.count];
    for (Class type in mandatoryTypes.componentTypes) {
        [mandatoryTypeClassNames addObject:NSStringFromClass(type)];
    }

    return [NSString stringWithFormat:@"%@ is '%@' for type '%i' with system '%@' triggered by '%@' with mandatory components '%@'",
                                      [super description],
                                      activated,
                                      _notificationType,
                                      NSStringFromClass([_clientSystem class]),
                                      [triggeringTypeClassNames componentsJoinedByString:@", "],
                                      [mandatoryTypeClassNames componentsJoinedByString:@", "]];
}


@end


@implementation ESReactiveSystem (CollectionObserver)

- (void)entity:(ESEntity *)changedEntity changedInCollection:(ESCollection *)collection withChangeType:(ESEntityChange)changeType {
    ESEntity *originalEntity = changedEntity;
    if (![_collectedEntities containsObject:originalEntity]) {
        [_collectedEntities addObject:originalEntity];
    }
}

@end
