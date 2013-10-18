#import "Kiwi.h"
#import "ESMatcher.h"
#import "ESComponent.h"
#import "SomeComponent.h"
#import "SomeOtherComponent.h"
#import "ESEntity.h"
#import "ESEntities.h"
#import "SomeThirdComponent.h"

SPEC_BEGIN(ESComponentSpec)

describe(@"ESComponent", ^{



    it(@"should return a matcher that matches itself", ^{

        ESMatcher *matcher = [ESComponent matcher];
        [matcher shouldNotBeNil];
        [[matcher should] beKindOfClass:[ESMatcher class]];

    });

    context(@"with a matcher", ^{

        __block ESEntities *entities;
        __block ESMatcher *matcher;
        beforeEach(^{
            matcher = [SomeComponent matcher];
            entities = [ESEntities new];
        });

        it(@"should match an entity that contains the component", ^{

            ESEntity *entity = [entities createEntity];
            [entity addComponent:[SomeComponent new]];
            [entity addComponent:[SomeOtherComponent new]];

            BOOL isMatching = [matcher areComponentsMatching:[entity componentTypes]];

            [[theValue(isMatching) should] beYes];

        });


        it(@"should not match an entity that doesn't contain the component", ^{

            ESEntity *entity = [entities createEntity];
            [entity addComponent:[SomeOtherComponent new]];
            [entity addComponent:[SomeThirdComponent new]];

            BOOL isMatching = [matcher areComponentsMatching:[entity componentTypes]];

            [[theValue(isMatching) should] beNo];

        });

    });
      
});

SPEC_END
