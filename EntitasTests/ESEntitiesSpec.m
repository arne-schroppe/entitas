#import "Kiwi.h"
#import "ESEntities.h"
#import "ESEntity.h"
#import "SomeComponent.h"
#import "ESCollection.h"

SPEC_BEGIN(ESEntitiesSpec)

        describe(@"ESEntities", ^{

            __block ESEntities *entities = nil;

            beforeEach(^{
                entities = [[ESEntities alloc] init];
            });

            it(@"should be instantiated", ^{
                [entities shouldNotBeNil];
                [[entities should] beKindOfClass:[ESEntities class]];
            });

            it(@"should create an entity", ^{
                ESEntity *entity = [entities createEntity];
                [entity shouldNotBeNil];
                [[entity should] beKindOfClass:[ESEntity class]];
            });

            it(@"should contain an entity it created", ^{
                ESEntity *entity = [entities createEntity];
                [[theValue([entities containsEntity:entity]) should] equal:theValue(YES)];
            });

            it(@"should not contain an entity it didn't create", ^{
                ESEntity *entity = [[ESEntity alloc] init];
                [[theValue([entities containsEntity:entity]) should] equal:theValue(NO)];
            });

            it(@"should not contain an entity that has been destroyed", ^{
                ESEntity *entity = [entities createEntity];
                [entities destroyEntity:entity];
                [[theValue([entities containsEntity:entity]) should] equal:theValue(NO)];
            });

            it(@"should return a subset of all entities which contain the given component types", ^{
                [entities createEntity];
                SomeComponent *someComponent = [[SomeComponent alloc] init];
                ESEntity *entityWithSomeComponent = [entities createEntity];
                [entityWithSomeComponent addComponent:someComponent];

                NSArray *entitiesWithSomeComponent = [entities getEntitiesWithComponentsOfTypes:[NSSet setWithObject:[SomeComponent class]]];

                [[entitiesWithSomeComponent should] contain:entityWithSomeComponent];
                [[entitiesWithSomeComponent should] haveCountOf:1];

            });

            it(@"should return an empty array if no entities contain the given component types", ^{
                [entities createEntity];

                NSArray *entitiesWithSomeComponent = [entities getEntitiesWithComponentsOfTypes:[NSSet setWithObject:[SomeComponent class]]];

                [[entitiesWithSomeComponent should] beEmpty];
            });

            it(@"should add a reference to itself when creating and entity", ^{
                ESEntity *entity = [entities createEntity];
                [[entity.entities should] equal:entities];
            });

            it(@"should return a collection with the given set", ^{
                NSSet *set = [NSSet set];
                ESCollection *collection = [entities getCollection:set];
                [[[collection types] should] equal:set];
            });

            it(@"should return the same instance of collections with the same set", ^{
                NSSet *set = [NSSet set];
                ESCollection *collectionA = [entities getCollection:set];
                ESCollection *collectionB = [entities getCollection:set];
                [[collectionA should] equal:collectionB];
            });

            it(@"should add an entity to a collection", ^{
                NSSet *set = [NSSet setWithObject:[SomeComponent class]];
                ESCollection *collection = [entities getCollection:set];
                ESEntity *entity = [entities createEntity];
                [entity addComponent:[[SomeComponent alloc] init] ];
                [[[collection entities] should] contain:entity];
            });

            it(@"should remove an entity from a collection", ^{
                NSSet *set = [NSSet setWithObject:[SomeComponent class]];
                ESCollection *collection = [entities getCollection:set];
                ESEntity *entity = [entities createEntity];
                [entity addComponent:[[SomeComponent alloc] init] ];
                [entity removeComponentOfType:[SomeComponent class]];
                [[[collection entities] shouldNot] contain:entity];
            });

            it(@"should add an entity to the collection that existed before the collection", ^{
                NSSet *set = [NSSet setWithObject:[SomeComponent class]];
                ESEntity *entity = [entities createEntity];
                [entity addComponent:[[SomeComponent alloc] init] ];
                ESCollection *collection = [entities getCollection:set];
                [[[collection entities] should] contain:entity];
            });

        });

SPEC_END