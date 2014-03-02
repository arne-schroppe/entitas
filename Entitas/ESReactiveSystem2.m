#import "ESMatcher.h"
#import "ESSystem.h"
#import "ESEntityRepository.h"
#import "ESReactiveSystem2.h"
#import "ESReactiveSubSystem.h"
#import "ESEntityRepository+Internal.h"


@interface ESReactiveSystem2 (CollectionObserver) <ESCollectionObserver>

@end


@implementation ESReactiveSystem2 {
	ESMatcher *_triggerComponents;
    ESEntityRepository *_entityRepository;

    ESCollection *_watcherCollection;
    NSMutableArray *_collectedEntities;

    BOOL _isActive;
    ESMatcher *_mandatoryComponents;

	void(^_execute)(NSArray*);
}


- (void)dealloc {
    [_watcherCollection removeObserver:self forEvent:_notificationType];
}


- (id)initWithEntityRepository:(ESEntityRepository *)entityRepository
			  notificationType:(ESEntityChange)type
					  triggers:(ESMatcher *)triggerComponents
				  executeBlock:(void(^)(NSArray*))execute {

    self = [super init];
    if (self) {

        _entityRepository = entityRepository;
        _notificationType = type;
        _collectedEntities = [[NSMutableArray alloc] init];
		_triggerComponents = triggerComponents;
        _watcherCollection = [_entityRepository collectionForMatcher:_triggerComponents];
        self.mandatoryComponents = [ESMatcher allOf:nil]; //allow everything by default

		_execute = execute;
		if(_execute == nil) {
			_execute = ^(NSArray *entities){};
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

    _execute(entitiesForCurrentExecution);
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

    NSMutableArray *triggeringTypeClassNames = [NSMutableArray arrayWithCapacity:_triggerComponents.componentTypes.count];
    for (Class type in _triggerComponents.componentTypes) {
        [triggeringTypeClassNames addObject:NSStringFromClass(type)];
    }

	ESMatcher *mandatoryTypes = self.mandatoryComponents;
    NSMutableArray *mandatoryTypeClassNames = [NSMutableArray arrayWithCapacity:mandatoryTypes.componentTypes.count];
    for (Class type in mandatoryTypes.componentTypes) {
        [mandatoryTypeClassNames addObject:NSStringFromClass(type)];
    }

    return [NSString stringWithFormat:@"%@ is '%@' for type '%i' triggered by '%@' with mandatory components '%@'",
                                      [super description],
                                      activated,
                                      _notificationType,
                                      [triggeringTypeClassNames componentsJoinedByString:@", "],
                                      [mandatoryTypeClassNames componentsJoinedByString:@", "]];
}


@end


@implementation ESReactiveSystem2 (CollectionObserver)

- (void)entity:(ESEntity *)changedEntity changedInCollection:(ESCollection *)collection withChangeType:(ESEntityChange)changeType {
    ESEntity *originalEntity = changedEntity;
    if (![_collectedEntities containsObject:originalEntity]) {
        [_collectedEntities addObject:originalEntity];
    }
}

@end
