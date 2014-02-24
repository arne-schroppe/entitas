#import "Kiwi.h"
#import "ESEntityRepository.h"
#import "ESEntity.h"
#import "SomeComponent.h"
#import "ESCollection.h"
#import "SomeOtherComponent.h"
#import "SomeThirdComponent.h"
#import "ESEntityRepository+Internal.h"
#import "ESCollection+Internal.h"

SPEC_BEGIN(ESEntityRepositorySpec)

        describe(@"ESEntityRepository", ^{

            __block ESEntityRepository *repo = nil;

            beforeEach(^{
                repo = [[ESEntityRepository alloc] init];
            });

            it(@"should be instantiated", ^{
                [repo shouldNotBeNil];
                [[repo should] beKindOfClass:[ESEntityRepository class]];
            });

            it(@"should create an entity", ^{
                ESEntity *entity = [repo createEntity];
                [entity shouldNotBeNil];
                [[entity should] beKindOfClass:[ESEntity class]];
            });

            it(@"should contain an entity it created", ^{
                ESEntity *entity = [repo createEntity];
                [[theValue([repo containsEntity:entity]) should] equal:theValue(YES)];
            });

            it(@"should not contain an entity it didn't create", ^{
                ESEntity *entity = [[ESEntity alloc] init];
                [[theValue([repo containsEntity:entity]) should] equal:theValue(NO)];
            });

            it(@"should not contain an entity that has been destroyed", ^{
                ESEntity *entity = [repo createEntity];
                [repo destroyEntity:entity];
                [[theValue([repo containsEntity:entity]) should] equal:theValue(NO)];
            });

            it(@"should contain an entity it created in allEntities", ^{
                ESEntity *entity = [repo createEntity];
                [[[repo allEntities] should] contain:entity];
            });

            it(@"should not contain an entity it didn't create in allEntities", ^{
                ESEntity *entity = [[ESEntity alloc] init];
                [[[repo allEntities] shouldNot] contain:entity];
            });

            it(@"should not contain an entity that has been destroyed in allEntities", ^{
                ESEntity *entity = [repo createEntity];
                [repo destroyEntity:entity];
                [[[repo allEntities] shouldNot] contain:entity];
            });

            it(@"should add a reference to itself when creating and entity", ^{
                ESEntity *entity = [repo createEntity];
                [[[entity valueForKey:@"_repository"] should] equal:repo];
            });

//            it(@"should return a collection with the given set", ^{
//                NSSet *set = [NSSet setWithObject:[SomeComponent class]];
//                ESCollection *collection = [repo collectionForTypes:set];
//                [[[collection types] should] equal:set];
//            });

            it(@"should return the same instance of collections with the same set", ^{
                NSSet *set = [NSSet setWithObject:[SomeComponent class]];
                ESCollection *collectionA = [repo collectionForTypes:set];
                ESCollection *collectionB = [repo collectionForTypes:set];
                [[collectionA should] equal:collectionB];
            });

            it(@"should add an entity to a collection", ^{
                NSSet *set = [NSSet setWithObject:[SomeComponent class]];
                ESCollection *collection = [repo collectionForTypes:set];
                ESEntity *entity = [repo createEntity];
                [entity addComponent:[[SomeComponent alloc] init] ];
                [[[collection entities] should] contain:entity];
            });

            it(@"should remove an entity from a collection", ^{
                NSSet *set = [NSSet setWithObject:[SomeComponent class]];
                ESCollection *collection = [repo collectionForTypes:set];
                ESEntity *entity = [repo createEntity];
                [entity addComponent:[[SomeComponent alloc] init] ];
                [entity removeComponentOfType:[SomeComponent class]];
                [[[collection entities] shouldNot] contain:entity];
            });

            it(@"should add an entity to the collection that existed before the collection", ^{
                NSSet *set = [NSSet setWithObject:[SomeComponent class]];
                ESEntity *entity = [repo createEntity];
                [entity addComponent:[[SomeComponent alloc] init] ];
                ESCollection *collection = [repo collectionForTypes:set];
                [[[collection entities] should] contain:entity];
            });

            it(@"should not attempt to add an entity to a collection that already contains it", ^{
                NSSet *set = [NSSet setWithObject:[SomeComponent class]];
                ESEntity *entity = [repo createEntity];
                [entity addComponent:[[SomeComponent alloc] init] ];
                ESCollection *collection = [repo collectionForTypes:set];
                [[[collection shouldNot] receive] addEntity:any() ];

                [entity addComponent:[[SomeOtherComponent alloc] init] ];
            });

            it(@"should not attempt to add an entity to an unrelated collection that shares some components", ^{
                NSSet *set = [NSSet setWithObjects:[SomeComponent class], [SomeOtherComponent class], nil];
                ESEntity *entity = [repo createEntity];
                [entity addComponent:[[SomeThirdComponent alloc] init] ];
                ESCollection *collection = [repo collectionForTypes:set];
                [[[collection shouldNot] receive] addEntity:any() ];
                [entity addComponent:[[SomeComponent alloc] init] ];
            });

            it(@"should not attempt to remove an entity from a collection that doesn't contain it", ^{
                NSSet *set = [NSSet setWithObject:[SomeOtherComponent class]];
                ESEntity *entity = [repo createEntity];
                [entity addComponent:[[SomeComponent alloc] init] ];
                ESCollection *collection = [repo collectionForTypes:set];
                [[[collection shouldNot] receive] removeEntity:any() ];
                [entity removeComponentOfType:[SomeComponent class]];
            });

            it(@"should not attempt to remove an entity from an unrelated collection that shares some components", ^{
                NSSet *set = [NSSet setWithObjects:[SomeComponent class], [SomeOtherComponent class], nil];
                ESEntity *entity = [repo createEntity];
                [entity addComponent:[[SomeComponent alloc] init] ];
                [entity addComponent:[[SomeThirdComponent alloc] init] ];
                ESCollection *collection = [repo collectionForTypes:set];
                [[[collection shouldNot] receive] removeEntity:any() ];
                [entity removeComponentOfType:[SomeComponent class]];
            });


            it(@"should add an entity to a collection when exchanging a component", ^{
                NSSet *set = [NSSet setWithObject:[SomeComponent class]];
                ESCollection *collection = [repo collectionForTypes:set];
                ESEntity *entity = [repo createEntity];
                [entity exchangeComponent:[[SomeComponent alloc] init] ];
                [[[collection entities] should] contain:entity];
            });

            it(@"should exchange an entity in a collection when exchanging a component", ^{
                NSSet *set = [NSSet setWithObject:[SomeComponent class]];
                ESCollection *collection = [repo collectionForTypes:set];
                ESEntity *entity = [repo createEntity];
                [entity exchangeComponent:[[SomeComponent alloc] init] ];
                [[[collection entities] should] contain:entity];
            });

            context(@"when destroying an entity", ^{

                it(@"should remove that entity from a collection containing it", ^{
                    NSSet *types = [NSSet setWithObject:[SomeComponent class]];
                    ESCollection *collection = [repo collectionForTypes:types];
                    ESEntity *entity = [repo createEntity];
                    [entity addComponent:[[SomeComponent alloc] init] ];
                    [repo destroyEntity:entity];
                    [[[collection entities] shouldNot] contain:entity];
                });

            });

            context(@"when requesting a collection with an empty types set", ^
            {

                it(@"should throw an exception", ^
                {
                    [[theBlock(^
                    {
                        [repo collectionForTypes:[NSSet set]];
                    }) should] raise];
                });

            });
        });

SPEC_END