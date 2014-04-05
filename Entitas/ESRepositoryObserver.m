#import "ESRepositoryObserver.h"
#import "ESEntityRepository+Internal.h"


@interface ESRepositoryObserver (CollectionObserver) <ESCollectionObserver>

@end


@implementation ESRepositoryObserver {
	id _target;
	ESCollection *_watcherCollection;
	NSMutableArray *_collectedEntities;
	ESEntityChange _changeTrigger;
}


- (id)initWithRepository:(ESEntityRepository *)repository matcher:(ESMatcher *)matcher target:(id)target {
	return [self initWithRepository:repository matcher:matcher target:target trigger:ESEntityAdded];
}

- (id)initWithRepository:(ESEntityRepository *)repository matcher:(ESMatcher *)matcher target:(id)target trigger:(ESEntityChange)changeTrigger
{
	self = [super init];
	if (self) {
		NSAssert(repository != nil, @"Repository cannot be nil");
		NSAssert(matcher != nil, @"Matcher cannot be nil");
		NSAssert(target != nil, @"Target cannot be nil");

		_target = target;
		_changeTrigger = changeTrigger;
		_collectedEntities = [[NSMutableArray alloc] init];
		_watcherCollection = [repository collectionForMatcher:matcher];
		[self startListening];
	}

	return self;
}


- (void)executeWithCollectedEntities {
	if( _collectedEntities.count == 0) {
		return;
	}

	NSArray *entitiesForTarget = _collectedEntities;
	_collectedEntities = [[NSMutableArray alloc] init];
	[_target executeWithEntities:entitiesForTarget];
}


- (void)deactivate {
	_collectedEntities = [[NSMutableArray alloc] init];
	[self stopListening];
}


- (void)activate {
	[self startListening];
}


- (void)startListening {
	[_watcherCollection addObserver:self forEvent:_changeTrigger];
}


- (void)stopListening {
	[_watcherCollection removeObserver:self forEvent:_changeTrigger];
}


@end


@implementation ESRepositoryObserver (CollectionObserver)

- (void)entity:(ESEntity *)changedEntity changedInCollection:(ESCollection *)collection withChangeType:(ESEntityChange)changeType {
	ESEntity *originalEntity = changedEntity;
	if (![_collectedEntities containsObject:originalEntity]) {
		[_collectedEntities addObject:originalEntity];
	}
}

@end
