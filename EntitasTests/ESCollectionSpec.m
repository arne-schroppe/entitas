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
        __block id notificationReceiver;

        beforeEach(^{
            set = [NSSet set];
            collection = [[ESCollection alloc] initWithTypes:set];
            entity = [[ESEntity alloc] init];
            changedEntity = [[ESChangedEntity alloc] initWithOriginalEntity:entity components:nil changeType:ESEntityAddedToCollection];
            notificationReceiver = [KWMock mock];
        });

        it(@"should be instantiated", ^{
            [collection shouldNotBeNil];
            [[collection should] beKindOfClass:[ESCollection class]];
        });

        it(@"should be initialized with a Set", ^{
            [[[collection types] should] equal:set];
        });

        it(@"should add an entity", ^{
            [collection addEntity:changedEntity];
            [[[collection entities] should] contain:entity];
        });

        it(@"should remove an entity", ^{
            [collection addEntity:changedEntity];
            [collection removeEntity:changedEntity];
            [[[collection entities] shouldNot] contain:entity];
        });

        it(@"should not add an entity more than once", ^{
            [collection addEntity:changedEntity];
            [collection addEntity:changedEntity];
            [[[collection entities] should] contain:entity];
            [[[collection entities] should] haveCountOf:1];
        });

        it(@"should notify observers when an entity is added", ^{
            id observer = [KWMock mockWithName:@"collection observer" forProtocol:@protocol(ESCollectionObserver)];
            [collection addObserver:observer forEvent:ESEntityAdded];
            [[observer should] receive:@selector(entity:changedInCollection:withEvent:) withCount:1 arguments:changedEntity, collection, ESEntityAdded];
            [collection addEntity:changedEntity];
        });

//        it(@"should post a notfication when an entity is added the contains an ESChangedEntity object", ^{
//            [notificationReceiver stub:@selector(notification) withBlock:(id (^)(NSArray *params)) ^
//            {
//                NSNotification *notification = [params objectAtIndex:0];
//                ESChangedEntity *changedEntity = [notification.userInfo objectForKey:[ESChangedEntity class]];
//                [[changedEntity shouldNot] beNil];
//                [[changedEntity should] beKindOfClass:[ESChangedEntity class]];
//            }];
//            [[NSNotificationCenter defaultCenter] addObserver:notificationReceiver selector:@selector(notification) name:ESEntityAdded object:collection];
//            [[notificationReceiver should] receive:@selector(notification) withCount:1];
//            [collection addEntity:entity becauseOfAddedComponent:nil];
//        });

        it(@"should notify observers when an entity is removed", ^{
            id observer = [KWMock mockWithName:@"collection observer" forProtocol:@protocol(ESCollectionObserver)];
            [collection addObserver:observer forEvent:ESEntityRemoved];
            [[observer should] receive:@selector(entity:changedInCollection:withEvent:) withCount:1 arguments:changedEntity, collection, ESEntityRemoved];
            [collection addEntity:changedEntity];
            [collection removeEntity:changedEntity];
        });

        it(@"should not notify observers that have been removed", ^{
            id observer = [KWMock mockWithName:@"collection observer" forProtocol:@protocol(ESCollectionObserver)];
            [collection addObserver:observer forEvent:ESEntityRemoved];
            [collection removeObserver:observer forEvent:ESEntityRemoved];
            [[observer shouldNot] receive:@selector(entity:changedInCollection:withEvent:) withCount:1 arguments:changedEntity, collection, ESEntityRemoved];
            [collection addEntity:changedEntity];
            [collection removeEntity:changedEntity];
        });
        
        context(@"Collection is provided by Entities", ^{
            //Given
            ESEntities *entities = [[ESEntities alloc]init];
            ESEntity *e1 = [entities createEntity];
            ESEntity *e2 = [entities createEntity];
            [e1 addComponent:[SomeComponent new]];
            [e2 addComponent:[SomeComponent new]];
            ESCollection *collection = [entities collectionForTypes:[NSSet setWithObject:[SomeComponent class]]];
            
            it(@"should be possible to remove components on entities during the loop. There for return a copy of entities set.", ^{
                
                [[[collection entities] should] haveCountOf:2];
                
                for(ESEntity *e in collection.entities){
                    [e removeComponentOfType:[SomeComponent class]];
                }
                
                [[[collection entities] should] haveCountOf:0];
            });
        });


    });

SPEC_END