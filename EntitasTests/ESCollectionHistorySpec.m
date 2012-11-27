#import "Kiwi.h"
#import "ESCollectionHistory.h"
#import "ESCollection.h"
#import "ESChangedEntity.h"

SPEC_BEGIN(ESCollectionHistorySpec)

        describe(@"ESCollectionHistory", ^{

            __block ESCollectionHistory *history = nil;
            __block ESCollection *collection = nil;

            beforeEach(^{
                collection = [[ESCollection alloc] init];
                history = [[ESCollectionHistory alloc] initWithCollection:collection];
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
                    ESEntity *entity = [[ESEntity alloc] init];
                    [collection addEntity:entity];
                    [[[history changes] should] beEmpty];
                });

            });

            context(@"when recording was started and stopped", ^{

                beforeEach(^{
                    [history startRecording];
                    [history stopRecording];
                });

                it(@"should not record a change when an entity is added to the collection", ^{
                    ESEntity *entity = [[ESEntity alloc] init];
                    [collection addEntity:entity];
                    [[[history changes] should] beEmpty];
                });

            });

            context(@"when recording was started", ^{

                beforeEach(^{
                    [history startRecording];
                });

                it(@"should contain a changedentity when an entity is added to the collection", ^{
                    ESEntity *entity = [[ESEntity alloc] init];
                    [collection addEntity:entity];
                    [[[history changes] should] have:1];
                    ESChangedEntity *changedEntity = [[history changes] objectAtIndex:0];
                    [[[changedEntity getOriginalEntity] should] equal:entity];
                });

                it(@"should contain a changedentity when an entity is removed from the collection", ^{
                    ESEntity *entity = [[ESEntity alloc] init];
                    [collection addEntity:entity];
                    [collection removeEntity:entity];
                    [[[history changes] should] have:2];
                    ESChangedEntity *changedEntity = [[history changes] objectAtIndex:1];
                    [[[changedEntity getOriginalEntity] should] equal:entity];
                });

                it(@"should not contain previous changes when the history was cleared", ^{
                    ESEntity *entity = [[ESEntity alloc] init];
                    [collection addEntity:entity];
                    [collection removeEntity:entity];
                    [history clearChanges];
                    [[[history changes] should] beEmpty];
                });


            });

        });

SPEC_END