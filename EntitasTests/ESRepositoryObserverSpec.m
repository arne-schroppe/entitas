#import "Kiwi.h"
#import "ESRepositoryObserver.h"
#import "SomeComponent.h"
#import "SomeOtherComponent.h"
#import "ESEntity+Internal.h"


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
                ESRepositoryObserver *_ = [[ESRepositoryObserver alloc] initWithRepository:repository matcher:triggeringMatcher];
            }) should] raiseWithName:NSInternalInconsistencyException];
        });


        it(@"does not allow the repository to be nil", ^{
            ESMatcher *triggeringMatcher = [ESMatcher just:[SomeComponent class]];
            [[theBlock(^{
                ESRepositoryObserver *_ = [[ESRepositoryObserver alloc] initWithRepository:nil matcher:triggeringMatcher];
            }) should] raiseWithName:NSInternalInconsistencyException];
        });

    });


    it(@"returns collected entities", ^{

        ESMatcher *triggeringMatcher = [ESMatcher just:[SomeComponent class]];
        ESRepositoryObserver *repoObserver = [[ESRepositoryObserver alloc] initWithRepository:repository matcher:triggeringMatcher];

        ESEntity *entity = [repository createEntity];
        [entity addComponent:[[SomeComponent alloc] init]];

		NSArray *entities = [repoObserver drain];

        [[entities should] equal:@[entity]];
    });


    it(@"returns only entities the owner is interested in", ^{

        ESEntity *entity = [repository createEntity];
        [entity addComponent:[[SomeComponent alloc] init]];
        [entity addComponent:[[SomeOtherComponent alloc] init]];

        ESEntity *entity2 = [repository createEntity];
        [entity2 addComponent:[SomeOtherComponent new]];

        ESMatcher *triggeringMatcher = [ESMatcher allOf:[SomeComponent class], [SomeOtherComponent class], nil];
        ESRepositoryObserver *repoObserver = [[ESRepositoryObserver alloc] initWithRepository:repository matcher:triggeringMatcher trigger:ESEntityRemoved];

        [entity removeComponentOfType:[SomeComponent class]];
        [entity removeComponentOfType:[SomeOtherComponent class]];

		NSArray *entities = [repoObserver drain];

        [[entities should] equal:@[entity]];
    });


    it(@"tracks entities that had components removed", ^{

        ESEntity *entity = [repository createEntity];
        [entity addComponent:[[SomeComponent alloc] init]];

        ESMatcher *triggeringMatcher = [ESMatcher just:[SomeComponent class]];
        ESRepositoryObserver *repoObserver = [[ESRepositoryObserver alloc] initWithRepository:repository matcher:triggeringMatcher trigger:ESEntityRemoved];

        [entity removeComponentOfType:[SomeComponent class]];

		NSArray *entities = [repoObserver drain];

        [[entities should] equal:@[entity]];
    });


    it(@"collects an entity only once", ^{

        ESMatcher *triggeringMatcher = [ESMatcher allOf:[SomeComponent class], [SomeOtherComponent class], nil];
        ESRepositoryObserver *repoObserver = [[ESRepositoryObserver alloc] initWithRepository:repository matcher:triggeringMatcher];

        ESEntity *entity = [repository createEntity];
        [entity addComponent:[[SomeComponent alloc] init]];

        [entity addComponent:[[SomeOtherComponent alloc] init]];
        [entity removeComponentOfType:[SomeOtherComponent class]];
        [entity addComponent:[[SomeOtherComponent alloc] init]];

		NSArray *entities = [repoObserver drain];

        [[entities should] equal:@[entity]];
    });


    it(@"returns an empty array if no entities were collected", ^{

        ESMatcher *triggeringMatcher = [ESMatcher just:[SomeComponent class]];
        ESRepositoryObserver *repoObserver = [[ESRepositoryObserver alloc] initWithRepository:repository matcher:triggeringMatcher];

        NSArray *entities = [repoObserver drain];

		[[entities should] beEmpty];
	});


    it(@"clears the collected entities after execution", ^{


        ESMatcher *triggeringMatcher = [ESMatcher just:[SomeComponent class]];
        ESRepositoryObserver *repoObserver = [[ESRepositoryObserver alloc] initWithRepository:repository matcher:triggeringMatcher];

        ESEntity *entity = [repository createEntity];
        [entity addComponent:[SomeComponent new]];

		NSArray *entities = [repoObserver drain];
        [[entities should] equal:@[entity]];

		NSArray *entities2 = [repoObserver drain];
		[[entities2 should] beEmpty];
    });


    it(@"tracks an entity only once, even though it's component was removed twice", ^{

        ESEntity *entity = [repository createEntity];
        [entity addComponent:[[SomeComponent alloc] init]];

        ESMatcher *triggeringMatcher = [ESMatcher just:[SomeComponent class]];
        ESRepositoryObserver *repoObserver = [[ESRepositoryObserver alloc] initWithRepository:repository matcher:triggeringMatcher trigger:ESEntityRemoved];

        [entity removeComponentOfType:[SomeComponent class]];
        [entity addComponent:[[SomeComponent alloc] init]];
        [entity removeComponentOfType:[SomeComponent class]];

		NSArray *entities = [repoObserver drain];

        [[entities should] equal:@[entity]];

    });


    it(@"does not exclude empty entities", ^{

        ESEntity *entity = [repository createEntity];
        [entity addComponent:[[SomeComponent alloc] init]];
        [entity addComponent:[[SomeOtherComponent alloc] init]];

        ESMatcher *triggeringMatcher = [ESMatcher just:[SomeComponent class]];
        ESRepositoryObserver *repoObserver = [[ESRepositoryObserver alloc] initWithRepository:repository matcher:triggeringMatcher trigger:ESEntityRemoved];

        [entity removeComponentOfType:[SomeComponent class]];
        [entity removeComponentOfType:[SomeOtherComponent class]];

		NSArray *entities = [repoObserver drain];

        [[entities should] equal:@[entity]];
    });


    it(@"clears collected entities on deactivation", ^{

        ESMatcher *triggeringMatcher = [ESMatcher just:[SomeComponent class]];
        ESRepositoryObserver *repoObserver = [[ESRepositoryObserver alloc] initWithRepository:repository matcher:triggeringMatcher];

        ESEntity *entity = [repository createEntity];
        [entity addComponent:[[SomeComponent alloc] init]];

        ESEntity *entity2 = [repository createEntity];
        [entity2 addComponent:[[SomeComponent alloc] init]];

        [repoObserver deactivate];
        [repoObserver activate];

        ESEntity *entity3 = [repository createEntity];
        [entity3 addComponent:[[SomeComponent alloc] init]];
        [entity3 addComponent:[[SomeOtherComponent alloc] init]];


		NSArray *entities = [repoObserver drain];

        [[entities shouldNot] contain:entity];
        [[entities shouldNot] contain:entity2];
        [[entities should] equal:@[entity3]];
    });


    it(@"does not collect entities while deactivated", ^{

        ESMatcher *triggeringMatcher = [ESMatcher just:[SomeComponent class]];
        ESRepositoryObserver *repoObserver = [[ESRepositoryObserver alloc] initWithRepository:repository matcher:triggeringMatcher];

        [repoObserver deactivate];

        ESEntity *entity = [repository createEntity];
        [entity addComponent:[[SomeComponent alloc] init]];

        ESEntity *entity2 = [repository createEntity];
        [entity2 addComponent:[[SomeComponent alloc] init]];

		NSArray *entities = [repoObserver drain];
		[[entities should] beEmpty];
	});


    it(@"discards entities that were changed while deactivated", ^{

        ESMatcher *triggeringMatcher = [ESMatcher just:[SomeComponent class]];
        ESRepositoryObserver *repoObserver = [[ESRepositoryObserver alloc] initWithRepository:repository matcher:triggeringMatcher];

        [repoObserver deactivate];

        ESEntity *entity = [repository createEntity];
        [entity addComponent:[[SomeComponent alloc] init]];

        ESEntity *entity2 = [repository createEntity];
        [entity2 addComponent:[[SomeComponent alloc] init]];

        [repoObserver activate];

        ESEntity *entity3 = [repository createEntity];
        [entity3 addComponent:[[SomeComponent alloc] init]];
        [entity3 addComponent:[[SomeOtherComponent alloc] init]];

		NSArray *entities = [repoObserver drain];

        [[entities shouldNot] contain:entity];
        [[entities shouldNot] contain:entity2];
        [[entities should] equal:@[entity3]];
    });

});

SPEC_END