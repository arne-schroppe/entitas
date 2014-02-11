#import "Kiwi.h"
#import "ESCollection.h"
#import "ESEntity.h"
#import "ESEntities.h"
#import "SomeComponent.h"
#import "NSNotificationMatcher.h"
#import "ESChangedEntity.h"

registerMatcher(Notification)

SPEC_BEGIN(ESCollectionSpec)

    describe(@"ESCollection", ^{

        __block ESCollection *collection;
        __block NSSet *set;
        __block ESEntity *entity;
        __block ESChangedEntity *changedEntity;

        beforeEach(^{
            set = [NSSet set];
            collection = [[ESCollection alloc] initWithTypes:set];
            entity = [[ESEntity alloc] init];
            changedEntity = [[ESChangedEntity alloc] initWithOriginalEntity:entity components:nil changeType:ESEntityAdded];
        });

        it(@"should be instantiated", ^{
            [collection shouldNotBeNil];
            [[collection should] beKindOfClass:[ESCollection class]];
        });

        it(@"should add an entity", ^{
            [collection addEntity:changedEntity];
            [[[collection entities] should] contain:entity];
        });

        it(@"should remove an entity", ^{
            [collection addEntity:changedEntity];
            [collection removeEntity:changedEntity];
			NSArray *collectedEntities = [collection entities];
			[[collectedEntities shouldNot] contain:entity];
        });

        it(@"should not add an entity more than once", ^{
            [collection addEntity:changedEntity];
            [collection addEntity:changedEntity];
            [[[collection entities] should] contain:entity];
            [[[collection entities] should] haveCountOf:1];
        });

        it(@"should preserve the order of entities", ^{

            ESEntity *entity1 = [[ESEntity alloc] init];
            ESChangedEntity *changedEntity1 = [[ESChangedEntity alloc] initWithOriginalEntity:entity1 components:nil changeType:ESEntityAdded];
            [collection addEntity:changedEntity1];

            ESEntity *entity2 = [[ESEntity alloc] init];
            ESChangedEntity *changedEntity2 = [[ESChangedEntity alloc] initWithOriginalEntity:entity2 components:nil changeType:ESEntityAdded];
            [collection addEntity:changedEntity2];

            ESEntity *entity3 = [[ESEntity alloc] init];
            ESChangedEntity *changedEntity3 = [[ESChangedEntity alloc] initWithOriginalEntity:entity3 components:nil changeType:ESEntityAdded];
            [collection addEntity:changedEntity3];

            [[[collection entities] should] haveCountOf:3];
            [[[collection entities][0] should] beIdenticalTo:entity1];
            [[[collection entities][1] should] beIdenticalTo:entity2];
            [[[collection entities][2] should] beIdenticalTo:entity3];
        });

        it(@"should notify observers when an entity is added", ^{
            id observer = [KWMock mockWithName:@"collection observer" forProtocol:@protocol(ESCollectionObserver)];
            [collection addObserver:observer forEvent:ESEntityAdded];
            [[observer should] receive:@selector(entity:changedInCollection:) withCount:1 arguments:changedEntity, collection];
            [collection addEntity:changedEntity];
        });

        it(@"should notify observers when an entity is removed", ^{
            id observer = [KWMock mockWithName:@"collection observer" forProtocol:@protocol(ESCollectionObserver)];
            [collection addObserver:observer forEvent:ESEntityRemoved];
            [[observer should] receive:@selector(entity:changedInCollection:) withCount:1 arguments:changedEntity, collection];
            [collection addEntity:changedEntity];
            [collection removeEntity:changedEntity];
        });

        it(@"should not notify observers that have been removed", ^{
            id observer = [KWMock mockWithName:@"collection observer" forProtocol:@protocol(ESCollectionObserver)];
            [collection addObserver:observer forEvent:ESEntityRemoved];
            [collection removeObserver:observer forEvent:ESEntityRemoved];
            [[observer shouldNot] receive:@selector(entity:changedInCollection:) withCount:1 arguments:changedEntity, collection];
            [collection addEntity:changedEntity];
            [collection removeEntity:changedEntity];
        });

        it(@"should notify observers when an entity is removed and added", ^{
            [collection addEntity:changedEntity];
            ESChangedEntity *changedEntity1 = [[ESChangedEntity alloc] initWithOriginalEntity:entity components:nil changeType:ESEntityRemoved];
            ESChangedEntity *changedEntity2 = [[ESChangedEntity alloc] initWithOriginalEntity:entity components:nil changeType:ESEntityAdded];
            id observer1 = [KWMock mockWithName:@"collection observer" forProtocol:@protocol(ESCollectionObserver)];
            id observer2 = [KWMock mockWithName:@"collection observer" forProtocol:@protocol(ESCollectionObserver)];
            [collection addObserver:observer1 forEvent:ESEntityRemoved];
            [collection addObserver:observer2 forEvent:ESEntityAdded];
            [[observer1 should] receive:@selector(entity:changedInCollection:) withCount:1 arguments:changedEntity1, collection];
            [[observer2 should] receive:@selector(entity:changedInCollection:) withCount:1 arguments:changedEntity2, collection];
            [collection remove:changedEntity1 andAddEntity:changedEntity2];
        });



        it(@"should only notify observers of an added entity if the exchanged entity was not part of the collection before", ^{
            ESChangedEntity *changedEntity1 = [[ESChangedEntity alloc] initWithOriginalEntity:entity components:nil changeType:ESEntityRemoved];
            ESChangedEntity *changedEntity2 = [[ESChangedEntity alloc] initWithOriginalEntity:entity components:nil changeType:ESEntityAdded];
            id observer1 = [KWMock mockWithName:@"collection observer" forProtocol:@protocol(ESCollectionObserver)];
            id observer2 = [KWMock mockWithName:@"collection observer" forProtocol:@protocol(ESCollectionObserver)];
            [collection addObserver:observer1 forEvent:ESEntityRemoved];
            [collection addObserver:observer2 forEvent:ESEntityAdded];
            [[observer1 shouldNot] receive:@selector(entity:changedInCollection:) withCount:1 arguments:changedEntity1, collection];
            [[observer2 should] receive:@selector(entity:changedInCollection:) withCount:1 arguments:changedEntity2, collection];
            [collection remove:changedEntity1 andAddEntity:changedEntity2];
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