#import "Kiwi.h"
#import "ESEntities.h"
#import "ESEntity.h"
#import "SomeComponent.h"
#import "ESCollection.h"
#import "SomeOtherComponent.h"
#import "SomeThirdComponent.h"

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

            it(@"should contain an entity it created in allEntities", ^{
                ESEntity *entity = [entities createEntity];
                [[[entities allEntities] should] contain:entity];
            });

            it(@"should not contain an entity it didn't create in allEntities", ^{
                ESEntity *entity = [[ESEntity alloc] init];
                [[[entities allEntities] shouldNot] contain:entity];
            });

            it(@"should not contain an entity that has been destroyed in allEntities", ^{
                ESEntity *entity = [entities createEntity];
                [entities destroyEntity:entity];
                [[[entities allEntities] shouldNot] contain:entity];
            });

            it(@"should add a reference to itself when creating and entity", ^{
                ESEntity *entity = [entities createEntity];
                [[entity.entities should] equal:entities];
            });

            it(@"should return a collection with the given set", ^{
                NSSet *set = [NSSet setWithObject:[SomeComponent class]];
                ESCollection *collection = [entities collectionForTypes:set];
                [[[collection types] should] equal:set];
            });

            it(@"should return the same instance of collections with the same set", ^{
                NSSet *set = [NSSet setWithObject:[SomeComponent class]];
                ESCollection *collectionA = [entities collectionForTypes:set];
                ESCollection *collectionB = [entities collectionForTypes:set];
                [[collectionA should] equal:collectionB];
            });

            it(@"should add an entity to a collection", ^{
                NSSet *set = [NSSet setWithObject:[SomeComponent class]];
                ESCollection *collection = [entities collectionForTypes:set];
                ESEntity *entity = [entities createEntity];
                [entity addComponent:[[SomeComponent alloc] init] ];
                [[[collection entities] should] contain:entity];
            });

            it(@"should remove an entity from a collection", ^{
                NSSet *set = [NSSet setWithObject:[SomeComponent class]];
                ESCollection *collection = [entities collectionForTypes:set];
                ESEntity *entity = [entities createEntity];
                [entity addComponent:[[SomeComponent alloc] init] ];
                [entity removeComponentOfType:[SomeComponent class]];
                [[[collection entities] shouldNot] contain:entity];
            });

            it(@"should add an entity to the collection that existed before the collection", ^{
                NSSet *set = [NSSet setWithObject:[SomeComponent class]];
                ESEntity *entity = [entities createEntity];
                [entity addComponent:[[SomeComponent alloc] init] ];
                ESCollection *collection = [entities collectionForTypes:set];
                [[[collection entities] should] contain:entity];
            });

            it(@"should not attempt to add an entity to a collection that already contains it", ^{
                NSSet *set = [NSSet setWithObject:[SomeComponent class]];
                ESEntity *entity = [entities createEntity];
                [entity addComponent:[[SomeComponent alloc] init] ];
                ESCollection *collection = [entities collectionForTypes:set];
                [[[collection shouldNot] receive] addEntity:any() ];

                [entity addComponent:[[SomeOtherComponent alloc] init] ];
            });

            it(@"should not attempt to add an entity to an unrelated collection that shares some components", ^{
                NSSet *set = [NSSet setWithObjects:[SomeComponent class], [SomeOtherComponent class], nil];
                ESEntity *entity = [entities createEntity];
                [entity addComponent:[[SomeThirdComponent alloc] init] ];
                ESCollection *collection = [entities collectionForTypes:set];
                [[[collection shouldNot] receive] addEntity:any() ];
                [entity addComponent:[[SomeComponent alloc] init] ];
            });

            it(@"should not attempt to remove an entity from a collection that doesn't contain it", ^{
                NSSet *set = [NSSet setWithObject:[SomeOtherComponent class]];
                ESEntity *entity = [entities createEntity];
                [entity addComponent:[[SomeComponent alloc] init] ];
                ESCollection *collection = [entities collectionForTypes:set];
                [[[collection shouldNot] receive] removeEntity:any() ];
                [entity removeComponentOfType:[SomeComponent class]];
            });

            it(@"should not attempt to remove an entity from an unrelated collection that shares some components", ^{
                NSSet *set = [NSSet setWithObjects:[SomeComponent class], [SomeOtherComponent class], nil];
                ESEntity *entity = [entities createEntity];
                [entity addComponent:[[SomeComponent alloc] init] ];
                [entity addComponent:[[SomeThirdComponent alloc] init] ];
                ESCollection *collection = [entities collectionForTypes:set];
                [[[collection shouldNot] receive] removeEntity:any() ];
                [entity removeComponentOfType:[SomeComponent class]];
            });


            it(@"should add an entity to a collection when exchanging a component", ^{
                NSSet *set = [NSSet setWithObject:[SomeComponent class]];
                ESCollection *collection = [entities collectionForTypes:set];
                ESEntity *entity = [entities createEntity];
                [entity exchangeComponent:[[SomeComponent alloc] init] ];
                [[[collection entities] should] contain:entity];
            });

            it(@"should exchange an entity in a collection when exchanging a component", ^{
                NSSet *set = [NSSet setWithObject:[SomeComponent class]];
                ESCollection *collection = [entities collectionForTypes:set];
                ESEntity *entity = [entities createEntity];
                [entity exchangeComponent:[[SomeComponent alloc] init] ];
                [[[collection entities] should] contain:entity];
            });

            it(@"should add ids to new entities", ^{

                ESEntity *entity1 = [entities createEntity];
                ESEntity *entity2 = [entities createEntity];
                ESEntity *entity3 = [entities createEntity];

                [[theValue(entity1.id) should] equal:theValue(1)];
                [[theValue(entity2.id) should] equal:theValue(2)];
                [[theValue(entity3.id) should] equal:theValue(3)];
            });

            context(@"when destroying an entity", ^{

                it(@"should remove that entity from a collection containing it", ^{
                    NSSet *types = [NSSet setWithObject:[SomeComponent class]];
                    ESCollection *collection = [entities collectionForTypes:types];
                    ESEntity *entity = [entities createEntity];
                    [entity addComponent:[[SomeComponent alloc] init] ];
                    [entities destroyEntity:entity];
                    [[[collection entities] shouldNot] contain:entity];
                });

            });

            context(@"when requesting a collection with an empty types set", ^
            {

                it(@"should throw an exception", ^
                {
                    [[theBlock(^
                    {
                        [entities collectionForTypes:[NSSet set]];
                    }) should] raise];
                });

            });
        });

SPEC_END