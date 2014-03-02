#import "Kiwi.h"

SPEC_BEGIN(ZZZSpec)

describe(@"ZZZ", ^{

    it(@"should flush gcov so that code coverage data is generated", ^{
        __gcov_flush();
    });
});

SPEC_END
