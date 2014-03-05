#import "ESMatcher.h"
#import "ESSystem.h"
#import "ESEntityRepository.h"
#import "ESReactiveSystem5.h"
#import "ESReactiveSubSystem5.h"
#import "ESEntityRepository+Internal.h"
#import "ESReactiveSystemSettings.h"


@interface ESReactiveSystem5 (CollectionObserver) <ESCollectionObserver>

@end


@implementation ESReactiveSystem5 {
    ESEntityRepository *_entityRepository;

    ESCollection *_watcherCollection;
    NSMutableArray *_collectedEntities;

    BOOL _isActive;


	ESMatcher *_triggeringComponents;
	ESMatcher *_mandatoryComponents;

}


- (void)dealloc {
    [_watcherCollection removeObserver:self forEvent:_notificationType];
}


- (id)initWithSystem:(NSObject <ESReactiveSubSystem5> *)system entityRepository:(ESEntityRepository *)entityRepository {
    NSAssert(system, @"Needs a system");

    self = [super init];
    if (self) {

        _entityRepository = entityRepository;
        _clientSystem = system;
        _collectedEntities = [[NSMutableArray alloc] init];

		ESReactiveSystemSettings *settings = [[ESReactiveSystemSettings alloc] init];
		[_clientSystem setUp:settings];

		NSAssert(settings.triggeringComponents != nil, @"You must at least set triggeringComponents on ESReactiveSystemSettings");

		_triggeringComponents = settings.triggeringComponents;
        _watcherCollection = [_entityRepository collectionForMatcher:_triggeringComponents];

		_notificationType = ESEntityAdded;
		if ([_clientSystem respondsToSelector:@selector(notificationType)]) {
			_notificationType = settings.changeType;
		}

        _mandatoryComponents = [ESMatcher allOf:nil]; //allow everything by default
        if (settings.mandatoryComponents != nil) {
            ESMatcher * mandatoryComponents = settings.mandatoryComponents;
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

    NSArray *entitiesForCurrentExecution = [_collectedEntities filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(ESEntity *evaluatedObject, NSDictionary *bindings) {
        return [_mandatoryComponents areComponentsMatching:evaluatedObject.componentTypes];
    }]];

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

    ESMatcher *triggeringTypes = _triggeringComponents;
    NSMutableArray *triggeringTypeClassNames = [NSMutableArray arrayWithCapacity:triggeringTypes.componentTypes.count];
    for (Class type in triggeringTypes.componentTypes) {
        [triggeringTypeClassNames addObject:NSStringFromClass(type)];
    }

	ESMatcher *mandatoryTypes = _mandatoryComponents;
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


@implementation ESReactiveSystem5 (CollectionObserver)

- (void)entity:(ESEntity *)changedEntity changedInCollection:(ESCollection *)collection withChangeType:(ESEntityChange)changeType {
    ESEntity *originalEntity = changedEntity;
    if (![_collectedEntities containsObject:originalEntity]) {
        [_collectedEntities addObject:originalEntity];
    }
}

@end
