#import "Kiwi.h"
#import "ESRepositoryObserver.h"
#import "ESMatcher.h"
#import "SomeComponent.h"
#import "ESEntityRepository.h"
#import "ESEntity.h"
#import "SomeOtherComponent.h"
#import "ESEntity+Internal.h"


@interface ObserverSystem : NSObject

@end

@implementation ObserverSystem

- (void)executeWithEntities:(NSArray *)entities {

}

@end



@interface EntitySpawningSystem2 : NSObject
- (id)initWithRepository:(ESEntityRepository *)entities;
@end

@implementation EntitySpawningSystem2 {
	ESEntityRepository *_entities;
	BOOL _hasCreatedEntity;
}

- (id)initWithRepository:(ESEntityRepository *)entities {
	self = [super init];
	if (self) {
		_entities = entities;
		_hasCreatedEntity = NO;
	}

	return self;
}

- (void)executeWithEntities:(NSArray *)entities {
	if (_hasCreatedEntity) {
		return;
	}
	ESEntity *newEntity = [_entities createEntity];
	[newEntity addComponent:[SomeComponent new]];
	[newEntity addComponent:[SomeOtherComponent new]];
	_hasCreatedEntity = YES;
}

@end




@interface BlockMatcher2 : NSObject <HCMatcher>
- (id)initWithBlock:(BOOL (^)(id))block;
@end

@implementation BlockMatcher2 {
	BOOL (^_block)(id);
}

- (id)initWithBlock:(BOOL (^)(id))block {
	self = [super init];
	if (self) {
		_block = block;
	}

	return self;
}

- (BOOL)matches:(id)item {
	return _block(item);
}
@end



SPEC_BEGIN(ESRepositoryObserverSpec)

describe(@"ESRepositoryObserver", ^{

	__block ESEntityRepository *repository;

	beforeEach(^{
		repository = [[ESEntityRepository alloc] init];
	});


	context(@"checking init arguments", ^{

		it(@"does not allow triggering components to be nil", ^{
			ESMatcher *triggeringMatcher = nil;
			[[theBlock(^{
				ESRepositoryObserver *_ = [[ESRepositoryObserver alloc] initWithRepository:repository matcher:triggeringMatcher target:[ObserverSystem new]];
			}) should] raiseWithName:NSInternalInconsistencyException];
		});


		it(@"does not allow the target to be nil", ^{
			ESMatcher *triggeringMatcher = [ESMatcher just:[SomeComponent class]];
			[[theBlock(^{
				ESRepositoryObserver *_ = [[ESRepositoryObserver alloc] initWithRepository:repository matcher:triggeringMatcher target:nil ];
			}) should] raiseWithName:NSInternalInconsistencyException];
		});


		it(@"does not allow the repository to be nil", ^{
			ESMatcher *triggeringMatcher = [ESMatcher just:[SomeComponent class]];
			[[theBlock(^{
				ESRepositoryObserver *_ = [[ESRepositoryObserver alloc] initWithRepository:nil matcher:triggeringMatcher target:[ObserverSystem new]];
			}) should] raiseWithName:NSInternalInconsistencyException];
		});

	});


	it(@"calls the target when entities were collected", ^{
		NSObject *target = [ObserverSystem nullMockWithName:@"target"];
		ESMatcher *triggeringMatcher = [ESMatcher just:[SomeComponent class]];
		ESRepositoryObserver *repoObserver = [[ESRepositoryObserver alloc] initWithRepository:repository matcher:triggeringMatcher target:target];

		ESEntity *entity = [repository createEntity];
		[entity addComponent:[[SomeComponent alloc] init]];

		[[target should] receive:@selector(executeWithEntities:)];

		[repoObserver executeWithCollectedEntities];
	});



	it(@"calls the target with collected entities", ^{
		KWMock *target = [ObserverSystem mockWithName:@"target"];
		KWCaptureSpy *spy = [target captureArgument:@selector(executeWithEntities:) atIndex:0];

		ESMatcher *triggeringMatcher = [ESMatcher just:[SomeComponent class]];
		ESRepositoryObserver *repoObserver = [[ESRepositoryObserver alloc] initWithRepository:repository matcher:triggeringMatcher target:target];

		ESEntity *entity = [repository createEntity];
		[entity addComponent:[[SomeComponent alloc] init]];

		[repoObserver executeWithCollectedEntities];

		[[spy.argument should] equal:@[entity]];
	});



	it(@"collects an entity only once", ^{
		KWMock *target = [ObserverSystem mockWithName:@"target"];
		KWCaptureSpy *spy = [target captureArgument:@selector(executeWithEntities:) atIndex:0];

		ESMatcher *triggeringMatcher = [ESMatcher allOf:[SomeComponent class], [SomeOtherComponent class], nil];
		ESRepositoryObserver *repoObserver = [[ESRepositoryObserver alloc] initWithRepository:repository matcher:triggeringMatcher target:target];

		ESEntity *entity = [repository createEntity];
		[entity addComponent:[[SomeComponent alloc] init]];

		[entity addComponent:[[SomeOtherComponent alloc] init]];
		[entity removeComponentOfType:[SomeOtherComponent class]];
		[entity addComponent:[[SomeOtherComponent alloc] init]];

		[repoObserver executeWithCollectedEntities];

		[[spy.argument should] equal:@[entity]];
	});




	it(@"does not notify the target if no entities were collected", ^{

		NSObject *target = [ObserverSystem nullMockWithName:@"target"];
		ESMatcher *triggeringMatcher = [ESMatcher just:[SomeComponent class]];
		ESRepositoryObserver *repoObserver = [[ESRepositoryObserver alloc] initWithRepository:repository matcher:triggeringMatcher target:target];

		[[target shouldNot] receive:@selector(executeWithEntities:)];

		[repoObserver executeWithCollectedEntities];
	});


	it(@"should clear the collected entities after execution", ^{
		KWMock *target = [ObserverSystem nullMockWithName:@"target"];
		KWCaptureSpy *spy = [target captureArgument:@selector(executeWithEntities:) atIndex:0];

		ESMatcher *triggeringMatcher = [ESMatcher just:[SomeComponent class]];
		ESRepositoryObserver *repoObserver = [[ESRepositoryObserver alloc] initWithRepository:repository matcher:triggeringMatcher target:target];

		ESEntity *entity = [repository createEntity];
		[entity addComponent:[SomeComponent new]];


		[repoObserver executeWithCollectedEntities];

		[[spy.argument should] equal:@[entity]];

		[[target shouldNot] receive:@selector(executeWithEntities:)];
		[repoObserver executeWithCollectedEntities];
	});


	it(@"should collect entities, that are added while the client system is executing, to a new collection which is used in the next execution", ^{


		EntitySpawningSystem2 *target = [[EntitySpawningSystem2 alloc] initWithRepository:repository];
		ESMatcher *triggeringMatcher = [ESMatcher just:[SomeComponent class]];
		ESRepositoryObserver *repoObserver = [[ESRepositoryObserver alloc] initWithRepository:repository matcher:triggeringMatcher target:target];


		ESEntity *entity = [repository createEntity];
		[entity addComponent:[SomeComponent new]];


		ESEntity *expectedEntity1 = [[ESEntity alloc] initWithIndex:0 inRepository:nil];
		[expectedEntity1 addComponent:[SomeComponent new]];

		[[target should] receive:@selector(executeWithEntities:) withArguments:[[BlockMatcher2 alloc] initWithBlock:^BOOL(NSArray *entities) {
			if (entities.count != 1) {
				return NO;
			}
			ESEntity *other = entities[0];
			return [other.componentTypes isEqualToSet:expectedEntity1.componentTypes];
		}]];
		[repoObserver executeWithCollectedEntities];

		ESEntity *expectedEntity2 = [[ESEntity alloc] initWithIndex:0 inRepository:nil];
		[expectedEntity2 addComponent:[SomeComponent new]];
		[expectedEntity2 addComponent:[SomeOtherComponent new]];

		[[target should] receive:@selector(executeWithEntities:) withArguments:[[BlockMatcher2 alloc] initWithBlock:^BOOL(NSArray *entities) {
			if (entities.count != 1) {
				return NO;
			}
			ESEntity *other = entities[0];
			return [other.componentTypes isEqualToSet:expectedEntity2.componentTypes];
		}]];
		[repoObserver executeWithCollectedEntities];

		[[target shouldNot] receive:@selector(executeWithEntities:)];
		[repoObserver executeWithCollectedEntities];
	});


});

SPEC_END