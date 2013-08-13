#import "Kiwi.h"
#import "ESAllMatcher.h"
#import "SomeComponent.h"
#import "SomeOtherComponent.h"

SPEC_BEGIN(ESAllMatcherSpec)

describe(@"ESAllMatcher", ^{

    __block ESAllMatcher *allMatcher;
    __block NSSet *componentTypes;
    __block ESMatcher *subMatcher1;
    __block ESMatcher *subMatcher2;
    __block ESMatcher *subMatcher3;

    beforeEach(^{
        componentTypes = [NSSet setWithObjects:[SomeComponent class], [SomeOtherComponent class], nil];

        subMatcher1 = [ESMatcher mockWithName:@"sub matcher 1"];
        subMatcher2 = [ESMatcher mockWithName:@"sub matcher 2"];
        subMatcher3 = [ESMatcher mockWithName:@"sub matcher 3"];

        //allMatcher = combineWithAND(subMatcher1, subMatcher2, subMatcher3, nil);

    });

    it(@"should match if all sub-matchers match", ^{

        [[subMatcher1 stubAndReturn:theValue(YES)] areComponentsMatching:componentTypes];
        [[subMatcher2 stubAndReturn:theValue(YES)] areComponentsMatching:componentTypes];
        [[subMatcher3 stubAndReturn:theValue(YES)] areComponentsMatching:componentTypes];

        BOOL isMatching = [allMatcher areComponentsMatching:componentTypes];

        [[theValue(isMatching) should] beYes];
    });


    it(@"should not match if any sub-matcher does not match", ^{

        [[subMatcher1 stubAndReturn:theValue(YES)] areComponentsMatching:componentTypes];
        [[subMatcher2 stubAndReturn:theValue(NO)] areComponentsMatching:componentTypes];
        [[subMatcher3 stubAndReturn:theValue(YES)] areComponentsMatching:componentTypes];

        BOOL isMatching = [allMatcher areComponentsMatching:componentTypes];

        [[theValue(isMatching) should] beNo];
    });


    it(@"should not match if no sub-matcher matches", ^{

        [[subMatcher1 stubAndReturn:theValue(NO)] areComponentsMatching:componentTypes];
        [[subMatcher2 stubAndReturn:theValue(NO)] areComponentsMatching:componentTypes];
        [[subMatcher3 stubAndReturn:theValue(NO)] areComponentsMatching:componentTypes];

        BOOL isMatching = [allMatcher areComponentsMatching:componentTypes];

        [[theValue(isMatching) should] beNo];
    });

});

SPEC_END
