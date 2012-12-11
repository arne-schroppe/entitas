#import "Kiwi.h"
#import "ESSystems.h"
#import "ESSystem.h"

SPEC_BEGIN(ESSystemsSpec)

        describe(@"ESSystems", ^{

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

            it(@"should execute its sub-systems", ^{
                [[[systemMock should] receive] execute];
                [systems addSystem:systemMock];
                [systems execute];
            });

            it(@"should activate its sub-systems", ^{
                [[[systemMock should] receive] activate];
                [systems addSystem:systemMock];
                [systems activate];
            });

            it(@"should deactivate its sub-systems", ^{
                [[[systemMock should] receive] deactivate];
                [systems addSystem:systemMock];
                [systems deactivate];
            });

            it(@"should remove all sub-systems", ^
            {
                id otherSystemMock = [KWMock mockForProtocol:@protocol(ESSystem)];
                [systems addSystem:systemMock];
                [systems addSystem:otherSystemMock];
                [systems removeAllSystems];
                [[theValue([systems containsSystem:systemMock]) should] equal:theValue(NO)];
                [[theValue([systems containsSystem:otherSystemMock]) should] equal:theValue(NO)];
            });

        });
SPEC_END