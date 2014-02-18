#import "Kiwi.h"
#import "ESCollection.h"
#import "ESEntities.h"
#import "SomeComponent.h"
#import "ESCollection+Internal.h"
#import "ESEntity+Internal.h"

registerMatcher(Notification)

SPEC_BEGIN(ESCollectionSpec)

    describe(@"ESCollection", ^{

        __block ESCollection *collection;
        __block NSSet *set;
        __block ESEntity *entity;

        beforeEach(^{
            set = [NSSet set];
            collection = [[ESCollection alloc] initWithTypes:set];
            entity = [[ESEntity alloc] init];
        });

        it(@"should be instantiated", ^{
            [collection shouldNotBeNil];
            [[collection should] beKindOfClass:[ESCollection class]];
        });

        it(@"should add an entity", ^{
            [collection addEntity:entity];
            [[[collection entities] should] contain:entity];
        });

        it(@"should remove an entity", ^{
            [collection addEntity:entity];
            [collection removeEntity:entity];
            NSArray *collectedEntities = [collection entities];
            [[collectedEntities shouldNot] contain:entity];
        });

        it(@"should not add an entity more than once", ^{
            [collection addEntity:entity];
            [collection addEntity:entity];
            [[[collection entities] should] contain:entity];
            [[[collection entities] should] haveCountOf:1];
        });

        it(@"should preserve the order of entities", ^{

            ESEntity *entity1 = [[ESEntity alloc] initWithIndex:0 inRepository:nil ];
            [collection addEntity:entity1];

            ESEntity *entity2 = [[ESEntity alloc] initWithIndex:1 inRepository:nil ];
            [collection addEntity:entity2];

            ESEntity *entity3 = [[ESEntity alloc] initWithIndex:2 inRepository:nil ];
            [collection addEntity:entity3];

            [[[collection entities] should] haveCountOf:3];
            [[[collection entities][0] should] beIdenticalTo:entity1];
            [[[collection entities][1] should] beIdenticalTo:entity2];
            [[[collection entities][2] should] beIdenticalTo:entity3];
        });

        it(@"should notify observers when an entity is added", ^{
            id observer = [KWMock mockWithName:@"collection observer" forProtocol:@protocol(ESCollectionObserver)];
            [collection addObserver:observer forEvent:ESEntityAdded];
            [[observer should] receive:@selector(entity:changedInCollection:withChangeType:) withCount:1 arguments:entity, collection, theValue(ESEntityAdded)];
            [collection addEntity:entity];
        });

        it(@"should notify observers when an entity is removed", ^{
            id observer = [KWMock mockWithName:@"collection observer" forProtocol:@protocol(ESCollectionObserver)];
            [collection addObserver:observer forEvent:ESEntityRemoved];
            [[observer should] receive:@selector(entity:changedInCollection:withChangeType:) withCount:1 arguments:entity, collection, theValue(ESEntityRemoved)];
            [collection addEntity:entity];
            [collection removeEntity:entity];
        });

        it(@"should not notify observers that have been removed", ^{
            id observer = [KWMock mockWithName:@"collection observer" forProtocol:@protocol(ESCollectionObserver)];
            [collection addObserver:observer forEvent:ESEntityRemoved];
            [collection removeObserver:observer forEvent:ESEntityRemoved];
            [[observer shouldNot] receive:@selector(entity:changedInCollection:withChangeType:) withCount:1 arguments:entity, collection, theValue(ESEntityAdded)];
            [collection addEntity:entity];
            [collection removeEntity:entity];
        });

        it(@"should notify observers when an entity is removed and added", ^{
            [collection addEntity:entity];
            id observer1 = [KWMock mockWithName:@"collection observer" forProtocol:@protocol(ESCollectionObserver)];
            id observer2 = [KWMock mockWithName:@"collection observer" forProtocol:@protocol(ESCollectionObserver)];
            [collection addObserver:observer1 forEvent:ESEntityRemoved];
            [collection addObserver:observer2 forEvent:ESEntityAdded];
            [[observer1 should] receive:@selector(entity:changedInCollection:withChangeType:) withCount:1 arguments:entity, collection, theValue(ESEntityRemoved)];
            [[observer2 should] receive:@selector(entity:changedInCollection:withChangeType:) withCount:1 arguments:entity, collection, theValue(ESEntityAdded)];
            [collection exchangeEntity:entity];
        });



        it(@"should only notify observers of an added entity if the exchanged entity was not part of the collection before", ^{
            id observer1 = [KWMock mockWithName:@"collection observer" forProtocol:@protocol(ESCollectionObserver)];
            id observer2 = [KWMock mockWithName:@"collection observer" forProtocol:@protocol(ESCollectionObserver)];
            [collection addObserver:observer1 forEvent:ESEntityRemoved];
            [collection addObserver:observer2 forEvent:ESEntityAdded];
            [[observer1 shouldNot] receive:@selector(entity:changedInCollection:withChangeType:) withCount:1 arguments:entity, collection, theValue(ESEntityRemoved)];
            [[observer2 should] receive:@selector(entity:changedInCollection:withChangeType:) withCount:1 arguments:entity, collection, theValue(ESEntityAdded)];
            [collection exchangeEntity:entity];
        });

        it(@"should give back cached entities", ^{
            ESEntity *entity1 = [[ESEntity alloc] initWithIndex:0 inRepository:nil ];
            [collection addEntity:entity1];

            ESEntity *entity2 = [[ESEntity alloc] initWithIndex:1 inRepository:nil ];
            [collection addEntity:entity2];

            ESEntity *entity3 = [[ESEntity alloc] initWithIndex:2 inRepository:nil ];
            [collection addEntity:entity3];

            NSArray *entityArray = collection.entities;

            [[entityArray should] beIdenticalTo:collection.entities];

        });

        it(@"should not give back cached entities if new entity is added", ^{
            ESEntity *entity1 = [[ESEntity alloc] initWithIndex:0 inRepository:nil ];
            [collection addEntity:entity1];

            ESEntity *entity2 = [[ESEntity alloc] initWithIndex:1 inRepository:nil ];
            [collection addEntity:entity2];

            NSArray *entityArray = collection.entities;

            ESEntity *entity3 = [[ESEntity alloc] initWithIndex:2 inRepository:nil ];
            [collection addEntity:entity3];

            [[entityArray shouldNot] beIdenticalTo:collection.entities];

        });

        it(@"should not give back cached entities if an entity is removed", ^{
            ESEntity *entity1 = [[ESEntity alloc] initWithIndex:0 inRepository:nil ];
            [collection addEntity:entity1];

            ESEntity *entity2 = [[ESEntity alloc] initWithIndex:1 inRepository:nil ];
            [collection addEntity:entity2];

            NSArray *entityArray = collection.entities;

            [collection removeEntity:entity2];

            [[entityArray shouldNot] beIdenticalTo:collection.entities];

        });

        it(@"should give back cached entities if an entity not in collection is removed", ^{
            ESEntity *entity1 = [[ESEntity alloc] initWithIndex:0 inRepository:nil ];
            [collection addEntity:entity1];

            ESEntity *entity2 = [[ESEntity alloc] initWithIndex:1 inRepository:nil ];
            [collection addEntity:entity2];

            NSArray *entityArray = collection.entities;

            ESEntity *entity3 = [[ESEntity alloc] initWithIndex:2 inRepository:nil ];
            [collection removeEntity:entity3];

            [[entityArray should] beIdenticalTo:collection.entities];

        });

        it(@"should give back cached entities if an entity is exchanged", ^{
            ESEntity *entity1 = [[ESEntity alloc] initWithIndex:0 inRepository:nil ];
            [collection addEntity:entity1];

            ESEntity *entity2 = [[ESEntity alloc] initWithIndex:1 inRepository:nil ];
            [collection addEntity:entity2];

            NSArray *entityArray = collection.entities;

            [collection exchangeEntity:entity2];

            [[entityArray should] beIdenticalTo:collection.entities];

        });
        
        context(@"Collection is provided by Entities", ^{
            //Given
            ESEntities *entities = [[ESEntities alloc]init];
            ESEntity *e1 = [entities createEntity];
            ESEntity *e2 = [entities createEntity];
            [e1 addComponent:[SomeComponent new]];
            [e2 addComponent:[SomeComponent new]];
            ESCollection *collection1 = [entities collectionForTypes:[NSSet setWithObject:[SomeComponent class]]];
            
            it(@"should be possible to remove components on entities during the loop. There for return a copy of entities set.", ^{
                
                [[[collection1 entities] should] haveCountOf:2];
                
                for(ESEntity *e in collection1.entities){
                    [e removeComponentOfType:[SomeComponent class]];
                }
                
                [[[collection1 entities] should] haveCountOf:0];
            });
        });


    });

SPEC_END