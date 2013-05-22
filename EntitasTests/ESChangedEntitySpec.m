#import "Kiwi.h"
#import "ESEntities.h"
#import "ESChangedEntity.h"
#import "SomeComponent.h"

SPEC_BEGIN(ESChangedEntitySpec)

        describe(@"ESChangedEntity", ^
        {

            __block ESEntities *entities = nil;

            beforeEach(^
            {
                entities = [[ESEntities alloc] init];
            });

            it(@"should be instantiated", ^
            {
                ESChangedEntity *changedEntity = [[ESChangedEntity alloc] init];
                [changedEntity shouldNotBeNil];
                [[changedEntity should] beKindOfClass:[ESChangedEntity class]];
            });

            it(@"should contain the change type it was initialized with", ^{
                ESEntityChange changeType = ESEntityAdded;
                ESChangedEntity *changedEntity = [[ESChangedEntity alloc] initWithOriginalEntity:nil components:nil changeType:changeType];
                [[theValue([changedEntity changeType]) should] equal:theValue(changeType)];
            });

            it(@"should contain a reference to the original component", ^{
                ESEntity *originalEntity = [entities createEntity];
                ESChangedEntity *changedEntity = [[ESChangedEntity alloc] initWithOriginalEntity:originalEntity components:nil changeType:0];
                [[[changedEntity originalEntity] should] equal:originalEntity];
            });

            it(@"should get a component of type by the given components", ^{
                ESEntity *originalEntity = [entities createEntity];
                SomeComponent *someComponent = [[SomeComponent alloc] init];
                NSDictionary *components = [NSDictionary dictionaryWithObject:someComponent forKey:[SomeComponent class]];
                ESChangedEntity *changedEntity = [[ESChangedEntity alloc] initWithOriginalEntity:originalEntity components:components changeType:0];
                [[[changedEntity componentOfType:[SomeComponent class]] should] equal:someComponent];
            });

        });
SPEC_END
