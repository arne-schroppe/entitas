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

            it(@"should contain a reference to the original component", ^{
                ESEntity *originalEntity = [entities createEntity];
                ESChangedEntity *changedEntity = [[ESChangedEntity alloc] initWithOriginalEntity:originalEntity ChangedComponents:nil];
                [[[changedEntity getOriginalEntity] should] equal:originalEntity];
            });

            it(@"should get a component of type that is contained by the entity", ^{
                ESEntity *originalEntity = [entities createEntity];
                SomeComponent *someComponent = [[SomeComponent alloc] init];
                [originalEntity addComponent:someComponent];
                ESChangedEntity *changedEntity = [[ESChangedEntity alloc] initWithOriginalEntity:originalEntity ChangedComponents:nil];
                [[[changedEntity getComponentOfType:[SomeComponent class]] should] equal:someComponent];
            });

            it(@"should get a component of type that is contained by the given changed components", ^{
                ESEntity *originalEntity = [entities createEntity];
                SomeComponent *someComponent = [[SomeComponent alloc] init];
                ESChangedEntity *changedEntity = [[ESChangedEntity alloc] initWithOriginalEntity:originalEntity ChangedComponents:[NSArray arrayWithObject:someComponent]];
                [[[changedEntity getComponentOfType:[SomeComponent class]] should] equal:someComponent];
            });

        });
SPEC_END
