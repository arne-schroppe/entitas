#import <Foundation/Foundation.h>
#import "ESMatcher.h"
#import "Kiwi.h"

#import "ESSystems.h"
#import "ESReactiveSystemClient.h"
#import "ESEntityRepository.h"
#import "SomeComponent.h"
#import "SomeOtherComponent.h"
#import "ESReactiveSystem.h"
#import "ESEntityRepository+Internal.h"


@interface GXBlockMatcher : NSObject <HCMatcher>
- (id)initWithBlock:(BOOL (^)(id))block;
@end


@implementation GXBlockMatcher {
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



@interface IsSingleEntityWithComponentTypes : NSObject <HCMatcher>
- (id)initWithTypes:(NSSet *)types;
@end


@implementation IsSingleEntityWithComponentTypes {
	NSSet *_types;
}

- (id)initWithTypes:(NSSet *)types; {
	self = [super init];
	if (self) {
		_types = types;
	}

	return self;
}


- (BOOL)matches:(id)item {

	if (![item respondsToSelector:@selector(firstObject)]) {
		return NO;
	}

	NSArray *set = (NSArray *) item;
	if (set.count != 1) {
		return NO;
	}

	id containedItem = [set firstObject];
	if (![containedItem isMemberOfClass:[ESEntity class]]) {
		return NO;
	}

	ESEntity *containedEntity = (ESEntity *) containedItem;

	if (![containedEntity.componentTypes isEqualToSet:_types]) {
		return NO;
	}

	return YES;
}
@end




@interface EntitySpawningSystem : NSObject <ESReactiveSystemClient>
- (id)initWithEntities:(ESEntityRepository *)entities;
@end


@implementation EntitySpawningSystem {
	ESEntityRepository *_entities;
	BOOL _hasCreatedEntity;
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


- (id)initWithEntities:(ESEntityRepository *)entities {
	self = [super init];
	if (self) {
		_entities = entities;
		_hasCreatedEntity = NO;
	}

	return self;
}


- (ESMatcher *)triggeringComponents {
	return [ESMatcher just:[SomeComponent class]];
}

@end




SPEC_BEGIN(ESReactiveSystemSpec)

	describe(@"ESReactiveSystemSpec", ^{

		ESMatcher *emptyMatcher = [ESMatcher allOfSet:[NSSet set]];
		__block ESEntityRepository *entities;



		beforeEach(^{
			entities = [ESEntityRepository new];
		});


		//TODO should we really disallow this? How could this be useful?
		xit(@"should not allow triggering components to be empty", ^{
			// given
			NSObject <ESReactiveSystemClient> *system = (NSObject <ESReactiveSystemClient> *) [KWMock nullMockForProtocol:@protocol(ESReactiveSystemClient)];
			[system stub:@selector(triggeringComponents) andReturn:emptyMatcher];

			//then
			[[theBlock(^{
				ESReactiveSystem *_ = [[ESReactiveSystem alloc] initWithSystem:system entityRepository:entities notificationType:ESEntityAdded];
			}) should] raiseWithName:NSInternalInconsistencyException];
		});

		//TODO should we really disallow this? How could this be useful?
		xit(@"should not allow triggering components to be nil", ^{
			// given
			NSObject <ESReactiveSystemClient> *system = (NSObject <ESReactiveSystemClient> *) [KWMock nullMockForProtocol:@protocol(ESReactiveSystemClient)];
			[system stub:@selector(triggeringComponents) andReturn:nil];

			//then
			[[theBlock(^{
				ESReactiveSystem *_ = [[ESReactiveSystem alloc] initWithSystem:system entityRepository:entities notificationType:ESEntityAdded];
			}) should] raiseWithName:NSInternalInconsistencyException];
		});


		it(@"should not execute the client system if no entities were collected", ^{
			NSObject <ESReactiveSystemClient> *system = (NSObject <ESReactiveSystemClient> *) [KWMock mockForProtocol:@protocol(ESReactiveSystemClient)];
			[system stub:@selector(triggeringComponents) andReturn:[ESMatcher just:[SomeComponent class]]];
			[system stub:@selector(mandatoryComponents) andReturn:emptyMatcher];

			ESReactiveSystem *reactiveSystem = [[ESReactiveSystem alloc] initWithSystem:system entityRepository:entities notificationType:ESEntityAdded];


			[[system shouldNot] receive:@selector(executeWithEntities:)];
			[reactiveSystem execute];
		});


		it(@"should execute the client system with a collection of added entities", ^{
			KWMock *system = [KWMock mockForProtocol:@protocol(ESReactiveSystemClient)];
			[system stub:@selector(triggeringComponents) andReturn:[ESMatcher just:[SomeComponent class]]];
			[system stub:@selector(mandatoryComponents) andReturn:emptyMatcher];

			ESReactiveSystem *reactiveSystem = [[ESReactiveSystem alloc] initWithSystem:(NSObject <ESReactiveSystemClient> *) system entityRepository:entities notificationType:ESEntityAdded];


			ESEntity *entity = [entities createEntity];
			[entity addComponent:[SomeComponent new]];

			[[system should] receive:@selector(executeWithEntities:) withArguments:[[IsSingleEntityWithComponentTypes alloc] initWithTypes:[NSSet setWithObject:[SomeComponent class]]]];
			[reactiveSystem execute];
		});


		it(@"should allow the use of component matchers for triggering components", ^{
			KWMock *system = [KWMock mockForProtocol:@protocol(ESReactiveSystemClient)];

			ESMatcher *matcher = [ESMatcher just:[SomeComponent class]];
			[system stub:@selector(triggeringComponents) andReturn:matcher];
			[system stub:@selector(mandatoryComponents) andReturn:emptyMatcher];


			ESReactiveSystem *reactiveSystem = [[ESReactiveSystem alloc] initWithSystem:(NSObject <ESReactiveSystemClient> *) system entityRepository:entities notificationType:ESEntityAdded];


			ESEntity *entity = [entities createEntity];
			[entity addComponent:[SomeComponent new]];

			[[system should] receive:@selector(executeWithEntities:) withArguments:[[IsSingleEntityWithComponentTypes alloc] initWithTypes:[NSSet setWithObject:[SomeComponent class]]]];
			[reactiveSystem execute];
		});


		it(@"should not execute its client system if a mandatory component is added, only when a triggering component is added", ^{
			KWMock *system = [KWMock mockForProtocol:@protocol(ESReactiveSystemClient)];
			[system stub:@selector(triggeringComponents) andReturn:[ESMatcher just:[SomeComponent class]]];
			[system stub:@selector(mandatoryComponents) andReturn:[ESMatcher just:[SomeOtherComponent class]]];

			ESEntity *entity = [entities createEntity];
			[entity addComponent:[SomeComponent new]];

			ESReactiveSystem *reactiveSystem = [[ESReactiveSystem alloc] initWithSystem:(NSObject <ESReactiveSystemClient> *) system entityRepository:entities notificationType:ESEntityAdded];


			[entity addComponent:[SomeOtherComponent new]];

			[[system shouldNot] receive:@selector(executeWithEntities:)];
			[reactiveSystem execute];
		});


		it(@"should only execute its client system with entities that still have all mandatory components", ^{
			KWMock *system = [KWMock mockForProtocol:@protocol(ESReactiveSystemClient)];
			[system stub:@selector(triggeringComponents) andReturn:[ESMatcher just:[SomeComponent class]]];
			[system stub:@selector(mandatoryComponents) andReturn:[ESMatcher just:[SomeOtherComponent class]]];

			ESEntity *entity = [entities createEntity];
			[entity addComponent:[SomeOtherComponent new]];

			ESEntity *entity2 = [entities createEntity];
			[entity2 addComponent:[SomeOtherComponent new]];

			ESReactiveSystem *reactiveSystem = [[ESReactiveSystem alloc] initWithSystem:(NSObject <ESReactiveSystemClient> *) system entityRepository:entities notificationType:ESEntityAdded];


			[entity addComponent:[SomeComponent new]];
			[entity2 addComponent:[SomeComponent new]];
			[entity2 removeComponentOfType:[SomeOtherComponent class]];

			[[system should] receive:@selector(executeWithEntities:) withArguments:[[IsSingleEntityWithComponentTypes alloc] initWithTypes:[NSSet setWithObjects:[SomeComponent class], [SomeOtherComponent class], nil ]]];
			[reactiveSystem execute];
		});


		it(@"should allow the use of component matchers for mandatory components", ^{

			KWMock *system = [KWMock mockForProtocol:@protocol(ESReactiveSystemClient)];
			ESMatcher *matcher = [ESMatcher just:[SomeOtherComponent class]];

			[system stub:@selector(triggeringComponents) andReturn:[ESMatcher just:[SomeComponent class]]];
			[system stub:@selector(mandatoryComponents) andReturn:matcher];

			ESEntity *entity = [entities createEntity];
			[entity addComponent:[SomeOtherComponent new]];

			ESEntity *entity2 = [entities createEntity];
			[entity2 addComponent:[SomeOtherComponent new]];

			ESReactiveSystem *reactiveSystem = [[ESReactiveSystem alloc] initWithSystem:(NSObject <ESReactiveSystemClient> *) system entityRepository:entities notificationType:ESEntityAdded];


			[entity addComponent:[SomeComponent new]];
			[entity2 addComponent:[SomeComponent new]];
			[entity2 removeComponentOfType:[SomeOtherComponent class]];

			[[system should] receive:@selector(executeWithEntities:) withArguments:[[IsSingleEntityWithComponentTypes alloc] initWithTypes:[NSSet setWithObjects:[SomeComponent class], [SomeOtherComponent class], nil ]]];
			[reactiveSystem execute];

		});


		it(@"should only listen to one collection", ^{
			KWMock *system = [KWMock mockForProtocol:@protocol(ESReactiveSystemClient)];
			[system stub:@selector(triggeringComponents) andReturn:[ESMatcher just:[SomeComponent class]]];
			[system stub:@selector(mandatoryComponents) andReturn:emptyMatcher];

			ESReactiveSystem *reactiveSystem = [[ESReactiveSystem alloc] initWithSystem:(NSObject <ESReactiveSystemClient> *) system entityRepository:entities notificationType:ESEntityAdded];


			ESEntity *entity = [entities createEntity];
			[entity addComponent:[SomeComponent new]];


			ESCollection *otherCollection = [entities collectionForMatcher:[ESMatcher just:[SomeOtherComponent class]]];
			ESEntity *otherEntity = [entities createEntity];
			[otherEntity addComponent:[SomeOtherComponent new]];

			[[system should] receive:@selector(executeWithEntities:) withArguments:[[IsSingleEntityWithComponentTypes alloc] initWithTypes:[NSSet setWithObject:[SomeComponent class]]]];
			[[system shouldNot] receive:@selector(executeWithEntities:) withArguments:[[IsSingleEntityWithComponentTypes alloc] initWithTypes:[NSSet setWithObject:[SomeOtherComponent class]]]];
			[reactiveSystem execute];

		});

		it(@"should execute the client system with a collection of entities that had components added", ^{
			KWMock *system = [KWMock mockForProtocol:@protocol(ESReactiveSystemClient)];
			[system stub:@selector(triggeringComponents) andReturn:[ESMatcher just:[SomeComponent class]]];
			[system stub:@selector(mandatoryComponents) andReturn:emptyMatcher];

			ESEntity *entity = [entities createEntity];

			ESReactiveSystem *reactiveSystem = [[ESReactiveSystem alloc] initWithSystem:(NSObject <ESReactiveSystemClient> *) system entityRepository:entities notificationType:ESEntityAdded];


			[entity addComponent:[SomeComponent new]];

			[[system should] receive:@selector(executeWithEntities:) withArguments:[[IsSingleEntityWithComponentTypes alloc] initWithTypes:[NSSet setWithObject:[SomeComponent class]]]];
			[reactiveSystem execute];
		});

		it(@"should execute the client system with a collection of non-duplicated entities, even when component is added twice", ^{
			KWMock *system = [KWMock mockForProtocol:@protocol(ESReactiveSystemClient)];
			[system stub:@selector(triggeringComponents) andReturn:[ESMatcher just:[SomeComponent class]]];
			[system stub:@selector(mandatoryComponents) andReturn:emptyMatcher];

			ESEntity *entity = [entities createEntity];

			ESReactiveSystem *reactiveSystem = [[ESReactiveSystem alloc] initWithSystem:(NSObject <ESReactiveSystemClient> *) system entityRepository:entities notificationType:ESEntityAdded];


			[entity addComponent:[SomeComponent new]];
			[entity exchangeComponent:[SomeComponent new]];

			[[system should] receive:@selector(executeWithEntities:) withArguments:[[IsSingleEntityWithComponentTypes alloc] initWithTypes:[NSSet setWithObject:[SomeComponent class]]]];
			[reactiveSystem execute];
		});


		it(@"should execute the client system with a collection of entities that had components removed", ^{
			KWMock *system = [KWMock nullMockForProtocol:@protocol(ESReactiveSystemClient)];
			[system stub:@selector(triggeringComponents) andReturn:[ESMatcher just:[SomeComponent class]]];
			[system stub:@selector(mandatoryComponents) andReturn:emptyMatcher];

			ESEntity *entity = [entities createEntity];
			[entity addComponent:[SomeComponent new]];
			[entity addComponent:[SomeOtherComponent new]];

			ESReactiveSystem *reactiveSystem = [[ESReactiveSystem alloc] initWithSystem:(NSObject <ESReactiveSystemClient> *) system entityRepository:entities notificationType:ESEntityRemoved];


			[entity removeComponentOfType:[SomeComponent class]];

			[[system should] receive:@selector(executeWithEntities:) withArguments:[[IsSingleEntityWithComponentTypes alloc] initWithTypes:[NSSet setWithObject:[SomeOtherComponent class]]]];
			[reactiveSystem execute];
		});


		it(@"should execute the client system with a collection of non-duplicated entities, even when component is removed twice", ^{
			KWMock *system = [KWMock nullMockForProtocol:@protocol(ESReactiveSystemClient)];
			[system stub:@selector(triggeringComponents) andReturn:[ESMatcher just:[SomeComponent class]]];
			[system stub:@selector(mandatoryComponents) andReturn:emptyMatcher];

			ESEntity *entity = [entities createEntity];
			[entity addComponent:[SomeComponent new]];
			[entity addComponent:[SomeOtherComponent new]];

			ESReactiveSystem *reactiveSystem = [[ESReactiveSystem alloc] initWithSystem:(NSObject <ESReactiveSystemClient> *) system entityRepository:entities notificationType:ESEntityRemoved];


			[entity removeComponentOfType:[SomeComponent class]];
			[entity addComponent:[SomeComponent new]];
			[entity removeComponentOfType:[SomeComponent class]];

			[[system should] receive:@selector(executeWithEntities:) withArguments:[[IsSingleEntityWithComponentTypes alloc] initWithTypes:[NSSet setWithObject:[SomeOtherComponent class]]]];
			[reactiveSystem execute];
		});


		it(@"should also include completely removed entities", ^{

			KWMock *system = [KWMock nullMockForProtocol:@protocol(ESReactiveSystemClient)];
			[system stub:@selector(triggeringComponents) andReturn:[ESMatcher just:[SomeComponent class]]];
			[system stub:@selector(mandatoryComponents) andReturn:emptyMatcher];

			ESEntity *entity = [entities createEntity];
			[entity addComponent:[SomeComponent new]];
			[entity addComponent:[SomeOtherComponent new]];

			ESReactiveSystem *reactiveSystem = [[ESReactiveSystem alloc] initWithSystem:(NSObject <ESReactiveSystemClient> *) system entityRepository:entities notificationType:ESEntityRemoved];


			[entities destroyEntity:entity];

			[[system should] receive:@selector(executeWithEntities:)];
			[reactiveSystem execute];
		});


		it(@"should execute the client system only with entities it's interested in", ^{
			KWMock *system = [KWMock mockForProtocol:@protocol(ESReactiveSystemClient)];
			[system stub:@selector(triggeringComponents) andReturn:[ESMatcher just:[SomeComponent class]]];
			[system stub:@selector(mandatoryComponents) andReturn:emptyMatcher];

			ESReactiveSystem *reactiveSystem = [[ESReactiveSystem alloc] initWithSystem:(NSObject <ESReactiveSystemClient> *) system entityRepository:entities notificationType:ESEntityAdded];


			ESEntity *entity = [entities createEntity];
			[entity addComponent:[SomeComponent new]];
			[entity addComponent:[SomeOtherComponent new]];

			ESEntity *entity2 = [entities createEntity];
			[entity2 addComponent:[SomeOtherComponent new]];

			[[system should] receive:@selector(executeWithEntities:) withArguments:[[IsSingleEntityWithComponentTypes alloc] initWithTypes:[NSSet setWithObjects:[SomeComponent class], [SomeOtherComponent class], nil]]];
			[reactiveSystem execute];
		});


		it(@"should clear the collected entities after execution", ^{
			KWMock *system = [KWMock mockForProtocol:@protocol(ESReactiveSystemClient)];
			[system stub:@selector(triggeringComponents) andReturn:[ESMatcher just:[SomeComponent class]]];
			[system stub:@selector(mandatoryComponents) andReturn:emptyMatcher];

			ESReactiveSystem *reactiveSystem = [[ESReactiveSystem alloc] initWithSystem:(NSObject <ESReactiveSystemClient> *) system entityRepository:entities notificationType:ESEntityAdded];


			ESEntity *entity = [entities createEntity];
			[entity addComponent:[SomeComponent new]];

			[[system should] receive:@selector(executeWithEntities:) withArguments:[[IsSingleEntityWithComponentTypes alloc] initWithTypes:[NSSet setWithObject:[SomeComponent class]]]];

			[reactiveSystem execute];

			[[system shouldNot] receive:@selector(executeWithEntities:)];
			[reactiveSystem execute];
		});


		it(@"should still clear the collected entities after execution even if no entity fulfilled the requirements", ^{

			KWMock *system = [KWMock mockForProtocol:@protocol(ESReactiveSystemClient)];
			[system stub:@selector(triggeringComponents) andReturn:[ESMatcher just:[SomeComponent class]]];
			[system stub:@selector(mandatoryComponents) andReturn:[ESMatcher just:[SomeOtherComponent class]]];

			ESReactiveSystem *reactiveSystem = [[ESReactiveSystem alloc] initWithSystem:(NSObject <ESReactiveSystemClient> *) system entityRepository:entities notificationType:ESEntityAdded];


			ESEntity *entity = [entities createEntity];
			[entity addComponent:[SomeComponent new]];
			[[system shouldNot] receive:@selector(executeWithEntities:)];
			[reactiveSystem execute];

			[entity addComponent:[SomeOtherComponent new]];
			[[system shouldNot] receive:@selector(executeWithEntities:)];
			[reactiveSystem execute];

		});


		it(@"should collect entities, that are added while the client system is executing, to a new collection which is used in the next execution", ^{

			EntitySpawningSystem *clientSystem = [[EntitySpawningSystem alloc] initWithEntities:entities];
			ESReactiveSystem *reactiveSystem = [[ESReactiveSystem alloc] initWithSystem:clientSystem entityRepository:entities notificationType:ESEntityAdded];


			ESEntity *entity = [entities createEntity];
			[entity addComponent:[SomeComponent new]];

			BOOL (^isEntityWithOneTestComponent)(id) = ^BOOL(id item) {
				if (![item respondsToSelector:@selector(firstObject)]) {
					return NO;
				}

				NSArray *collection = (NSArray *) item;
				if (collection.count != 1) {
					return NO;
				}

				id containedItem = [collection firstObject];
				if (![containedItem isMemberOfClass:[ESEntity class]]) {
					return NO;
				}

				ESEntity *containedEntity = (ESEntity *) containedItem;

				if (containedEntity.componentTypes.count != 1) {
					return NO;
				}

				if ([containedEntity componentOfType:[SomeComponent class]] == nil) {
					return NO;
				}

				return YES;
			};

			[[clientSystem should] receive:@selector(executeWithEntities:) withArguments:[[GXBlockMatcher alloc] initWithBlock:isEntityWithOneTestComponent]];
			[reactiveSystem execute];

			BOOL (^isEntityWithBothTestAndOtherComponent)(id) = ^BOOL(id item) {
				if (![item respondsToSelector:@selector(firstObject)]) {
					return NO;
				}

				NSArray *collection = (NSArray *) item;
				if (collection.count != 1) {
					return NO;
				}

				id containedItem = [collection firstObject];
				if (![containedItem isMemberOfClass:[ESEntity class]]) {
					return NO;
				}

				ESEntity *containedEntity = (ESEntity *) containedItem;
				if ([containedEntity componentOfType:[SomeComponent class]] == nil ||
						[containedEntity componentOfType:[SomeOtherComponent class]] == nil) {
					return NO;
				}

				return YES;
			};

			[[clientSystem should] receive:@selector(executeWithEntities:) withArguments:[[GXBlockMatcher alloc] initWithBlock:isEntityWithBothTestAndOtherComponent]];
			[reactiveSystem execute];


			[[clientSystem shouldNot] receive:@selector(executeWithEntities:)];
			[reactiveSystem execute];
		});

		it(@"should clear collections and remove observer on deactivation", ^{
			// given
			id clientSystem = [KWMock mockForProtocol:@protocol(ESReactiveSystemClient)];
			[clientSystem stub:@selector(triggeringComponents) andReturn:[ESMatcher just:[SomeComponent class]]];
			[clientSystem stub:@selector(mandatoryComponents) andReturn:emptyMatcher];

			ESCollection *watcherCollection = [ESCollection nullMockWithName:@"watcher collection"];
			[entities stub:@selector(collectionForMatcher:) andReturn:watcherCollection withArguments:[ESMatcher just:[SomeComponent class]]];
			ESReactiveSystem *reactiveSystem = [[ESReactiveSystem alloc] initWithSystem:clientSystem entityRepository:entities notificationType:ESEntityAdded];


			// expectation
			[[reactiveSystem.collectedEntities should] receive:@selector(removeAllObjects)];
			[[watcherCollection should] receive:@selector(removeObserver:forEvent:) withCount:1 arguments:reactiveSystem, theValue(ESEntityAdded)];

			// when
			[reactiveSystem deactivate];
		});

		it(@"should deactivate itself and than add itself as observer on activation", ^{
			// given
			id clientSystem = [KWMock mockForProtocol:@protocol(ESReactiveSystemClient)];
			[clientSystem stub:@selector(triggeringComponents) andReturn:[ESMatcher just:[SomeComponent class]]];
			[clientSystem stub:@selector(mandatoryComponents) andReturn:emptyMatcher];

			ESCollection *watcherCollection = [ESCollection nullMockWithName:@"watcher collection"];
			[entities stub:@selector(collectionForMatcher:) andReturn:watcherCollection withArguments:[ESMatcher just:[SomeComponent class]]];
			ESReactiveSystem *reactiveSystem = [[ESReactiveSystem alloc] initWithSystem:clientSystem entityRepository:entities notificationType:ESEntityAdded];


			// expectation
			[[reactiveSystem should] receive:@selector(deactivate)];
			[[watcherCollection should] receive:@selector(addObserver:forEvent:) withCount:1 arguments:reactiveSystem, theValue(ESEntityAdded)];

			// when
			[reactiveSystem activate];
		});
	});


SPEC_END