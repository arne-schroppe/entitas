#import "Kiwi.h"
#import "ESComponentMatcher.h"
#import "ESMatcherDSL.h"
#import "SomeComponent.h"
#import "SomeOtherComponent.h"
#import "SomeThirdComponent.h"


SPEC_BEGIN(ESComponentMatcherSpec)

describe(@"ESComponentMatcher", ^{


    __block NSObject<ESComponentMatcher> *componentMatcher;


    it(@"should match matchers combined with OR", ^{

        componentMatcher = combineWithOR(
            matchAllOf([SomeComponent class], [SomeOtherComponent class]),
            matchAnyOf([SomeThirdComponent class], [SomeOtherComponent class])
        );

        BOOL isMatching = [componentMatcher areComponentsMatching:[NSSet setWithObjects:[SomeThirdComponent class], nil]];
        [[theValue(isMatching) should] beYes];

        BOOL isMatching2 = [componentMatcher areComponentsMatching:[NSSet setWithObjects:[SomeComponent class], nil]];
        [[theValue(isMatching2) should] beNo];

        BOOL isMatching3 = [componentMatcher areComponentsMatching:[NSSet setWithObjects:[SomeComponent class], [SomeOtherComponent class], nil]];
        [[theValue(isMatching3) should] beYes];
    });


    it(@"should match matchers combined with AND", ^{

        componentMatcher = combineWithAND(
        matchAllOf([SomeComponent class], [SomeOtherComponent class]),
        matchAnyOf([SomeThirdComponent class], [SomeOtherComponent class])
        );

        BOOL isMatching = [componentMatcher areComponentsMatching:[NSSet setWithObjects:[SomeComponent class], [SomeThirdComponent class], nil]];
        [[theValue(isMatching) should] beNo];

        BOOL isMatching2 = [componentMatcher areComponentsMatching:[NSSet setWithObjects:[SomeComponent class], [SomeOtherComponent class], nil]];
        [[theValue(isMatching2) should] beYes];

        BOOL isMatching3 = [componentMatcher areComponentsMatching:[NSSet setWithObjects:[SomeComponent class], [SomeOtherComponent class], [SomeThirdComponent class], nil]];
        [[theValue(isMatching3) should] beYes];
    });
      
});

SPEC_END
