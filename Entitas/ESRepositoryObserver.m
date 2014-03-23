#import "ESRepositoryObserver.h"
#import "ESMatcher.h"
#import "ESEntityRepository.h"
#import "ESReactiveSubSystem5.h"
#import "ESCollection.h"
#import "ESEntityRepository+Internal.h"


@interface ESRepositoryObserver (CollectionObserver) <ESCollectionObserver>

@end


@implementation ESRepositoryObserver {
	id _target;
	ESCollection *_watcherCollection;
	NSMutableArray *_collectedEntities;
}


- (id)initWithRepository:(ESEntityRepository *)repository matcher:(ESMatcher *)matcher target:(id)target {
	self = [super init];
	if (self) {
		NSAssert(repository != nil, @"Repository cannot be nil");
		NSAssert(matcher != nil, @"Matcher cannot be nil");
		NSAssert(target != nil, @"Target cannot be nil");

		_target = target;
		_collectedEntities = [[NSMutableArray alloc] init];
		_watcherCollection = [repository collectionForMatcher:matcher];
		[_watcherCollection addObserver:self forEvent:ESEntityAdded];
	}

	return self;
}


- (void)executeWithCollectedEntities {
	if( _collectedEntities.count == 0) {
		return;
	}

	NSArray *entitiesForTarget = [_collectedEntities copy];
	_collectedEntities = [[NSMutableArray alloc] init];
	[_target executeWithEntities:entitiesForTarget];
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