#import "Kiwi.h"
#import "ESCollectionHistory.h"
#import "ESCollection.h"
#import "ESChangedEntity.h"
#import "ESCollection+Internal.h"

SPEC_BEGIN(ESCollectionHistorySpec)

        describe(@"ESCollectionHistory", ^{

            __block ESCollectionHistory *history = nil;
            __block ESCollection *collection = nil;
            __block ESEntity *entity = nil;

            beforeEach(^{
                collection = [[ESCollection alloc] initWithTypes:[NSSet new]];
                history = [[ESCollectionHistory alloc] initWithCollection:collection];
                entity = [ESEntity new];
            });

            it(@"should be instantiated", ^{
                [history shouldNotBeNil];
                [[history should] beKindOfClass:[ESCollectionHistory class]];
            });

            it(@"should contain the collection it was initialized with", ^{

                [[[history collection] should] equal:collection];
            });

            it(@"should not contain any changes initially", ^{
                [[[history changes] should] beEmpty];
            });

            context(@"when recording was not started", ^{

                it(@"should not record a change when an entity is added to the collection", ^{
                    ESChangedEntity *changedEntity = [[ESChangedEntity alloc] initWithOriginalEntity:entity components:nil changeType:ESEntityAdded];
                    [collection addEntity:changedEntity];
                    [[[history changes] should] beEmpty];
                });

            });

            context(@"when recording was started and stopped", ^{

                beforeEach(^{
                    [history startRecording];
                    [history stopRecording];
                });

                it(@"should not record a change when an entity is added to the collection", ^{
                    ESChangedEntity *changedEntity = [[ESChangedEntity alloc] initWithOriginalEntity:entity components:nil changeType:ESEntityAdded];
                    [collection addEntity:changedEntity];
                    [[[history changes] should] beEmpty];
                });

            });

            context(@"when recording was started", ^{

                beforeEach(^{
                    [history startRecording];
                });

                it(@"should store a changedentity when an entity is added to the collection", ^{
                    ESChangedEntity *originalChangedEntity = [[ESChangedEntity alloc] initWithOriginalEntity:entity components:nil changeType:ESEntityAdded];
                    [collection addEntity:originalChangedEntity];
                    [[[history changes] should] have:1];
                    ESChangedEntity *storedChangedEntity = [[history changes] objectAtIndex:0];
                    [[storedChangedEntity should] beIdenticalTo:originalChangedEntity];
                });

                it(@"should contain a changedentity when an entity is removed from the collection", ^{
                    ESChangedEntity *changedEntity1 = [[ESChangedEntity alloc] initWithOriginalEntity:entity components:nil changeType:ESEntityAdded];
                    ESChangedEntity *changedEntity2 = [[ESChangedEntity alloc] initWithOriginalEntity:entity components:nil changeType:ESEntityRemoved];
                    [collection addEntity:changedEntity1];
                    [collection removeEntity:changedEntity2];
                    [[[history changes] should] have:2];
                    ESChangedEntity *storedChangedEntity = [[history changes] objectAtIndex:1];
                    [[storedChangedEntity should] beIdenticalTo:changedEntity2];
                });

                it(@"should not contain previous changes when the history was cleared", ^{
                    [collection addEntity:[[ESChangedEntity alloc] initWithOriginalEntity:entity components:nil changeType:ESEntityAdded]];
                    [collection removeEntity:[[ESChangedEntity alloc] initWithOriginalEntity:entity components:nil changeType:ESEntityRemoved]];
                    [history clearChanges];
                    [[[history changes] should] beEmpty];
                });


            });

        });

SPEC_END