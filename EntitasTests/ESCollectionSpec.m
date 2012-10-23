#import "Kiwi.h"
#import "ESCollection.h"
#import "ESEntity.h"
#import "ESEntities.h"
#import "SomeComponent.h"

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

        it(@"should be initialized with a Set", ^{
            [[[collection types] should] equal:set];
        });

        it(@"should add an entity", ^{

            [collection addEntity:entity];
            [[[collection entities] should] contain:entity];
        });

        it(@"should remove an entity", ^{
            [collection addEntity:entity];
            [collection removeEntity:entity];
            [[[collection entities] shouldNot] contain:entity];
        });

        it(@"should not add an entity more than once", ^{
            [collection addEntity:entity];
            [collection addEntity:entity];
            [[[collection entities] should] contain:entity];
            [[[collection entities] should] haveCountOf:1];
        });
        
        context(@"Collection is provided by Entities", ^{
            //Given
            ESEntities *entities = [[ESEntities alloc]init];
            ESEntity *e1 = [entities createEntity];
            ESEntity *e2 = [entities createEntity];
            [e1 addComponent:[SomeComponent new]];
            [e2 addComponent:[SomeComponent new]];
            ESCollection *collection = [entities getCollectionForTypes:[NSSet setWithObject:[SomeComponent class]]];
            
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