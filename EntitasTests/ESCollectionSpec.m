#import "Kiwi.h"
#import "ESCollection.h"
#import "ESEntity.h"

SPEC_BEGIN(ESCollectionSpec)

    describe(@"ESCollection", ^{

        beforeEach(^{
        });

        it(@"should be instantiated", ^{
            ESCollection *collection = [[ESCollection alloc] init];
            [collection shouldNotBeNil];
            [[collection should] beKindOfClass:[ESCollection class]];
        });

        it(@"should be initialized with a Set", ^{
            NSSet *set = [NSSet set];
            ESCollection *collection = [[ESCollection alloc] initWithSet:set];
            [[[collection set] should] equal:set];
        });

        it(@"should add an entity", ^{
            ESEntity *entity = [[ESEntity alloc] init];
            NSSet *set = [NSSet set];
            ESCollection *collection = [[ESCollection alloc] initWithSet:set];
            [collection addEntity:entity];
            [[[collection entities] should] contain:entity];
        });

        it(@"should remove an entity", ^{
            ESEntity *entity = [[ESEntity alloc] init];
            NSSet *set = [NSSet set];
            ESCollection *collection = [[ESCollection alloc] initWithSet:set];
            [collection addEntity:entity];
            [collection removeEntity:entity];
            [[[collection entities] shouldNot] contain:entity];
        });

    });

SPEC_END