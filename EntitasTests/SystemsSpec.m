#import "Kiwi.h"
#import "ESSystems.h"
#import "ESSystem.h"

SPEC_BEGIN(SystemsSpec)
        describe(@"Systems", ^{

            __block ESSystems *systems = nil;
            __block id systemMock = nil;

            beforeEach(^{
                systems = [[ESSystems alloc] init];
                systemMock = [KWMock mockForProtocol:@protocol(ESSystem)];
            });

            it(@"should be instantiated", ^{
                [systems shouldNotBeNil];
                [[systems should] beKindOfClass:[ESSystems class]];
            });

            it(@"should be an ESSystem itself", ^{
                [[systems should] conformToProtocol:@protocol(ESSystem)];
            });

            it(@"should add a sub-system", ^{
                [systems addSystem:systemMock];
                [[theValue([systems containsSystem:systemMock]) should] equal:theValue(YES)];
            });

            it(@"should not contain a sub-system which hasn't been added", ^{
                [[theValue([systems containsSystem:systemMock]) should] equal:theValue(NO)];
            });

            it(@"should remove a sub-system", ^{
                [systems addSystem:systemMock];
                [systems removeSystem:systemMock];
                [[theValue([systems containsSystem:systemMock]) should] equal:theValue(NO)];
            });

        });
SPEC_END