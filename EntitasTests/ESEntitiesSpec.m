#import "Kiwi.h"
#import "ESEntities.h"
#import "ESEntity.h"
#import "SomeComponent.h"
#import "ESCollection.h"
#import "SomeOtherComponent.h"

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

            it(@"should add a reference to itself when creating and entity", ^{
                ESEntity *entity = [entities createEntity];
                [[entity.entities should] equal:entities];
            });

            it(@"should return a collection with the given set", ^{
                NSSet *set = [NSSet set];
                ESCollection *collection = [entities getCollectionForTypes:set];
                [[[collection types] should] equal:set];
            });

            it(@"should return the same instance of collections with the same set", ^{
                NSSet *set = [NSSet set];
                ESCollection *collectionA = [entities getCollectionForTypes:set];
                ESCollection *collectionB = [entities getCollectionForTypes:set];
                [[collectionA should] equal:collectionB];
            });

            it(@"should add an entity to a collection", ^{
                NSSet *set = [NSSet setWithObject:[SomeComponent class]];
                ESCollection *collection = [entities getCollectionForTypes:set];
                ESEntity *entity = [entities createEntity];
                [entity addComponent:[[SomeComponent alloc] init] ];
                [[[collection entities] should] contain:entity];
            });

            it(@"should remove an entity from a collection", ^{
                NSSet *set = [NSSet setWithObject:[SomeComponent class]];
                ESCollection *collection = [entities getCollectionForTypes:set];
                ESEntity *entity = [entities createEntity];
                [entity addComponent:[[SomeComponent alloc] init] ];
                [entity removeComponentOfType:[SomeComponent class]];
                [[[collection entities] shouldNot] contain:entity];
            });

            it(@"should add an entity to the collection that existed before the collection", ^{
                NSSet *set = [NSSet setWithObject:[SomeComponent class]];
                ESEntity *entity = [entities createEntity];
                [entity addComponent:[[SomeComponent alloc] init] ];
                ESCollection *collection = [entities getCollectionForTypes:set];
                [[[collection entities] should] contain:entity];
            });

            it(@"should not attempt to add an entity to a collection that already contains it", ^{
                NSSet *set = [NSSet setWithObject:[SomeComponent class]];
                ESEntity *entity = [entities createEntity];
                [entity addComponent:[[SomeComponent alloc] init] ];
                ESCollection *collection = [entities getCollectionForTypes:set];
                [[[collection shouldNot] receive] addEntity:entity becauseOfAddedComponent:nil];

                [entity addComponent:[[SomeOtherComponent alloc] init] ];
            });

            it(@"should not attempt to remove an entity from a collection that doesn't contain it", ^{
                NSSet *set = [NSSet setWithObject:[SomeOtherComponent class]];
                ESEntity *entity = [entities createEntity];
                [entity addComponent:[[SomeComponent alloc] init] ];
                ESCollection *collection = [entities getCollectionForTypes:set];
                [[[collection shouldNot] receive] removeEntity:entity becauseOfRemovedComponent:nil];
                [entity removeComponentOfType:[SomeComponent class]];
            });

            context(@"when destroying an entity", ^{

                it(@"should remove that entity from a collection containing it", ^{
                    NSSet *types = [NSSet setWithObject:[SomeComponent class]];
                    ESCollection *collection = [entities getCollectionForTypes:types];
                    ESEntity *entity = [entities createEntity];
                    [entity addComponent:[[SomeComponent alloc] init] ];
                    [entities destroyEntity:entity];
                    [[[collection entities] shouldNot] contain:entity];
                });

            });
        });

SPEC_END