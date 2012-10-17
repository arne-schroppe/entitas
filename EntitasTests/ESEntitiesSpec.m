#import "Kiwi.h"
#import "ESEntities.h"
#import "ESEntity.h"
#import "SomeComponent.h"

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

                NSMutableArray *entitiesWithSomeComponent = [entities getEntitiesWithComponentsOfTypes:@[[SomeComponent class]]];

                [[entitiesWithSomeComponent should] contain:entityWithSomeComponent];
                [[entitiesWithSomeComponent should] haveCountOf:1];

            });

            it(@"should return an empty array if no entities contain the given component types", ^{
                [entities createEntity];

                NSMutableArray *entitiesWithSomeComponent = [entities getEntitiesWithComponentsOfTypes:@[[SomeComponent class]]];

                [[entitiesWithSomeComponent should] beEmpty];
            });

        });

SPEC_END