#import "ESMatcher.h"
#import "ESSystem.h"
#import "ESEntityRepository.h"
#import "ESReactiveSystem.h"
#import "ESReactiveSystemClient.h"
#import "ESEntityRepository+Internal.h"


@implementation ESReactiveSystem {
	ESEntityRepository *_entityRepository;

	ESCollection *_watcherCollection;
	NSMutableArray *_collectedEntities;
	//NSPredicate *_entityRequirements;


	BOOL _isActive;
	ESMatcher *_mandatoryComponents;
}


- (void)dealloc {
	[_watcherCollection removeObserver:self forEvent:_notificationType];
}


- (id)initWithSystem:(NSObject <ESReactiveSystemClient> *)system entityRepository:(ESEntityRepository *)entityRepository notificationType:(ESEntityChange)type {
	NSAssert(system, @"Needs a system");

	self = [super init];
	if (self) {

		//[[JSObjection defaultInjector] injectDependencies:self];

		_entityRepository = entityRepository;
		_clientSystem = system;
		_notificationType = type;
		_collectedEntities = [[NSMutableArray alloc] init];

		id componentsOrMatcher = _clientSystem.triggeringComponentTypes;

		if([componentsOrMatcher isKindOfClass:[NSSet class]]) {
			NSSet *triggeringComponentSet = (NSSet *) componentsOrMatcher;
			NSAssert(triggeringComponentSet != nil && triggeringComponentSet.count > 0, @"Triggering components can't be empty");

			_watcherCollection = [_entityRepository collectionForMatcher:[ESMatcher allOfSet:triggeringComponentSet]];
		}
		else if ([componentsOrMatcher isKindOfClass:[ESMatcher class]]) {
			ESMatcher *matcher = componentsOrMatcher;
			_watcherCollection = [_entityRepository collectionForMatcher:matcher];
		}
		else {
			NSAssert(NO, @"Triggering components are of an unknown type (must be NSSet or ESComponentMatcher)");
		}


		_mandatoryComponents = [ESMatcher allOfSet:[NSSet set]]; //allow everything by default
		if ([_clientSystem respondsToSelector:@selector(mandatoryComponentTypes)]) {
			id mandatoryComponents  = _clientSystem.mandatoryComponentTypes;

			if(mandatoryComponents == nil || [mandatoryComponents isKindOfClass:[NSSet class]]) {
				NSSet *mandatoryComponentsSet = (NSSet *) mandatoryComponents;
				_mandatoryComponents = [ESMatcher allOfSet:mandatoryComponentsSet];
			}
			else if ([mandatoryComponents isKindOfClass:[ESMatcher class]]) {
				_mandatoryComponents = mandatoryComponents;
			}
		}

		[self activate];
	}

	return self;
}


- (void)entity:(ESEntity *)changedEntity changedInCollection:(ESCollection *)collection withChangeType:(ESEntityChange)changeType {
	ESEntity *originalEntity = changedEntity; //[changedEntity originalEntity];
	if (![_collectedEntities containsObject:originalEntity]) {
		[_collectedEntities addObject:originalEntity];
	}
}




- (void)execute {

	if (_collectedEntities.count == 0) {
		return;
	}

	NSArray *entitiesForCurrentExecution = [_collectedEntities filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(ESEntity *evaluatedObject, NSDictionary *bindings) {
		return /*[_entities containsEntity:evaluatedObject] && */ [_mandatoryComponents areComponentsMatching:evaluatedObject.componentTypes];
	}]];


	_collectedEntities = [[NSMutableArray alloc] init];

//	if (_features && ![_featuresService areFeaturesMatching:_features]) {
//		return;
//	}

	if (entitiesForCurrentExecution.count == 0) {
		return;
	}

	[_clientSystem executeWithEntities:[entitiesForCurrentExecution copy]];
}

- (void) activate {
	[self deactivate];
	[_watcherCollection addObserver:self forEvent:_notificationType];
	_isActive = YES;
}

- (void) deactivate {
	[_watcherCollection removeObserver:self forEvent:_notificationType];
	[_collectedEntities removeAllObjects];
	_isActive = NO;
}

- (NSString *)description {
	NSString *activated = _isActive ? @"active" : @"inactive";
//    NSMutableArray *featureClassNames = [NSMutableArray arrayWithCapacity:_features.count];
//    for (Class type in _features){
//        [featureClassNames addObject:NSStringFromClass(type)];
//    }

	NSSet *triggeringTypes = [_clientSystem triggeringComponentTypes];
	NSMutableArray *triggeringTypeClassNames = [NSMutableArray arrayWithCapacity:triggeringTypes.count];
	for (Class type in triggeringTypes){
		[triggeringTypeClassNames addObject:NSStringFromClass(type)];
	}

	NSSet *mandatoryTypes = [_clientSystem mandatoryComponentTypes];
	NSMutableArray *mandatoryTypeClassNames = [NSMutableArray arrayWithCapacity:mandatoryTypes.count];
	for (Class type in mandatoryTypes){
		[mandatoryTypeClassNames addObject:NSStringFromClass(type)];
	}

	//return [NSString stringWithFormat:@"%@ is '%@' for type '%i' and features '%@' with system '%@' triggered by '%@' with mandatory components '%@'",
	return [NSString stringWithFormat:@"%@ is '%@' for type '%i' with system '%@' triggered by '%@' with mandatory components '%@'",
									  [super description],
									  activated,
									  _notificationType,
			//[featureClassNames componentsJoinedByString:@", "],
									  NSStringFromClass([_clientSystem class]),
									  [triggeringTypeClassNames componentsJoinedByString:@", "],
									  [mandatoryTypeClassNames componentsJoinedByString:@", "]];
}


@end
