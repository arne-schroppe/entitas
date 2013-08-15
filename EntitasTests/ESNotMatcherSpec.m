#import "Kiwi.h"
#import "ESNotMatcher.h"
#import "SomeComponent.h"
#import "SomeOtherComponent.h"

SPEC_BEGIN(ESNotMatcherSpec)

describe(@"ESNotMatcher", ^{

    __block ESNotMatcher *notMatcher;
    __block NSSet *componentTypes;
    __block ESMatcher *subMatcher;

    beforeEach(^{
        componentTypes = [NSSet setWithObjects:[SomeComponent class], [SomeOtherComponent class], nil];

        subMatcher = [ESMatcher mockWithName:@"sub matcher"];
        //notMatcher = invertMatch(subMatcher);
    });

//    it(@"should match if its sub-matcher doesn't", ^{
//
//        [[subMatcher stubAndReturn:theValue(NO)] areComponentsMatching:componentTypes];
//        BOOL isMatching = [notMatcher areComponentsMatching:componentTypes];
//        [[theValue(isMatching) should] beYes];
//    });
//
//
//    it(@"should not match if its sub-matcher does", ^{
//
//        [[subMatcher stubAndReturn:theValue(YES)] areComponentsMatching:componentTypes];
//        BOOL isMatching = [notMatcher areComponentsMatching:componentTypes];
//        [[theValue(isMatching) should] beNo];
//    });
});

SPEC_END
