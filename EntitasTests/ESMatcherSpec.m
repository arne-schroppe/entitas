#import "ESEntityRepository.h"
#import "Kiwi.h"
#import "SomeComponent.h"
#import "SomeOtherComponent.h"
#import "SomeThirdComponent.h"
#import "ESMatcher.h"
#import "ESEntity+Internal.h"

SPEC_BEGIN(ESMatcherSpec)

    describe(@"ESMatcher", ^{


        __block ESMatcher *matcher;
        __block ESEntityRepository *repo;

        beforeEach(^{
            repo = [ESEntityRepository new];
        });


        context(@"for all component types", ^{

            it(@"should match if all component types are present in the entity", ^{
                matcher = [ESMatcher allOf:[SomeComponent class], [SomeOtherComponent class], nil];

                ESEntity *entity = [repo createEntity];
                [entity addComponent:[SomeComponent new]];
                [entity addComponent:[SomeOtherComponent new]];

                BOOL isMatching = [matcher areComponentsMatching:[entity componentTypes]];
                [[theValue(isMatching) should] beYes];
            });


            it(@"should match anything if matcher has no component types", ^{
                matcher = [ESMatcher allOf:nil];

                ESEntity *entity = [repo createEntity];
                [entity addComponent:[SomeComponent new]];
                [entity addComponent:[SomeOtherComponent new]];

                BOOL isMatching = [matcher areComponentsMatching:[entity componentTypes]];
                [[theValue(isMatching) should] beYes];
            });


            it(@"should match an empty entity if matcher has no component types", ^{
                matcher = [ESMatcher allOf:nil];

                ESEntity *entity = [repo createEntity];

                BOOL isMatching = [matcher areComponentsMatching:[entity componentTypes]];
                [[theValue(isMatching) should] beYes];
            });


            it(@"should not match if not all component types are present in the entity", ^{
                matcher = [ESMatcher allOf:[SomeComponent class], [SomeOtherComponent class], nil];

                ESEntity *entity = [repo createEntity];
                [entity addComponent:[SomeComponent new]];

                BOOL isMatching = [matcher areComponentsMatching:[entity componentTypes]];
                [[theValue(isMatching) should] beNo];
            });


            it(@"should be equal to another matcher of the same type with the same components", ^{
                matcher = [ESMatcher allOf:[SomeComponent class], [SomeOtherComponent class], nil];
                ESMatcher *otherMatcher = [ESMatcher allOf:[SomeOtherComponent class], [SomeComponent class], nil];

                [[theValue([matcher isEqual:otherMatcher]) should] beYes];
                [[theValue(matcher.hash) should] equal:theValue(otherMatcher.hash)];
            });


            it(@"should not be equal to another matcher if the type is different", ^{
                matcher = [ESMatcher allOf:[SomeComponent class], [SomeOtherComponent class], nil];
                ESMatcher *otherMatcher = [ESMatcher anyOf:[SomeOtherComponent class], [SomeComponent class], nil];

                [[theValue([matcher isEqual:otherMatcher]) should] beNo];
                [[theValue(matcher.hash) shouldNot] equal:theValue(otherMatcher.hash)];
            });


            it(@"should not be equal to another matcher if components are different", ^{
                matcher = [ESMatcher allOf:[SomeComponent class], nil];
                ESMatcher *otherMatcher = [ESMatcher allOf:[SomeOtherComponent class], nil];

                [[theValue([matcher isEqual:otherMatcher]) should] beNo];
            });

        });


        context(@"for any component types", ^{

            it(@"should match if any of the components are present", ^{
                matcher = [ESMatcher anyOf:[SomeComponent class], [SomeOtherComponent class], nil];

                ESEntity *entity = [repo createEntity];
                [entity addComponent:[SomeComponent new]];

                BOOL isMatching = [matcher areComponentsMatching:[entity componentTypes]];
                [[theValue(isMatching) should] beYes];
            });


            it(@"should not match if none of the components are present", ^{
                matcher = [ESMatcher anyOf:[SomeComponent class], [SomeOtherComponent class], nil];

                ESEntity *entity = [repo createEntity];
                [entity addComponent:[SomeThirdComponent new]];

                BOOL isMatching = [matcher areComponentsMatching:[entity componentTypes]];
                [[theValue(isMatching) should] beNo];
            });




            it(@"should match nothing if matcher has no component types", ^{
                matcher = [ESMatcher anyOf:nil];

                ESEntity *entity = [repo createEntity];
                [entity addComponent:[SomeComponent new]];
                [entity addComponent:[SomeOtherComponent new]];

                BOOL isMatching = [matcher areComponentsMatching:[entity componentTypes]];
                [[theValue(isMatching) should] beNo];
            });


            it(@"should not match an empty entity if matcher has no component types", ^{
                matcher = [ESMatcher anyOf:nil];

                ESEntity *entity = [repo createEntity];

                BOOL isMatching = [matcher areComponentsMatching:[entity componentTypes]];
                [[theValue(isMatching) should] beNo];
            });



            it(@"should be equal to another matcher of the same type with the same components", ^{
                matcher = [ESMatcher anyOf:[SomeComponent class], [SomeOtherComponent class], nil];
                ESMatcher *otherMatcher = [ESMatcher anyOf:[SomeOtherComponent class], [SomeComponent class], nil];

                [[theValue([matcher isEqual:otherMatcher]) should] beYes];
            });


            it(@"should not be equal to another matcher if the type is different", ^{
                matcher = [ESMatcher anyOf:[SomeComponent class], [SomeOtherComponent class], nil];
                ESMatcher *otherMatcher = [ESMatcher allOf:[SomeOtherComponent class], [SomeComponent class], nil];

                [[theValue([matcher isEqual:otherMatcher]) should] beNo];
            });


            it(@"should not be equal to another matcher if components are different", ^{
                matcher = [ESMatcher anyOf:[SomeComponent class], nil];
                ESMatcher *otherMatcher = [ESMatcher anyOf:[SomeOtherComponent class], nil];

                [[theValue([matcher isEqual:otherMatcher]) should] beNo];
            });

        });


        context(@"for just one component type", ^{

            it(@"should match if the component is present", ^{
                matcher = [ESMatcher just:[SomeComponent class]];

                ESEntity *entity = [repo createEntity];
                [entity addComponent:[SomeComponent new]];
                [entity addComponent:[SomeOtherComponent new]];

                BOOL isMatching = [matcher areComponentsMatching:[entity componentTypes]];
                [[theValue(isMatching) should] beYes];

            });


            it(@"should not match if the components are not present", ^{
                matcher = [ESMatcher just:[SomeComponent class]];

                ESEntity *entity = [repo createEntity];
                [entity addComponent:[SomeOtherComponent new]];

                BOOL isMatching = [matcher areComponentsMatching:[entity componentTypes]];
                [[theValue(isMatching) should] beNo];
            });


            it(@"should match if the component is nil", ^{
                matcher = [ESMatcher just:nil];

                ESEntity *entity = [repo createEntity];
                [entity addComponent:[SomeOtherComponent new]];

                BOOL isMatching = [matcher areComponentsMatching:[entity componentTypes]];
                [[theValue(isMatching) should] beYes];
            });


            it(@"should match an empty entity if the components is nil", ^{
                matcher = [ESMatcher just:nil];

                ESEntity *entity = [repo createEntity];

                BOOL isMatching = [matcher areComponentsMatching:[entity componentTypes]];
                [[theValue(isMatching) should] beYes];
            });


            it(@"should be equal to another matcher of the same type with the same components", ^{
                matcher = [ESMatcher just:[SomeComponent class]];

                ESMatcher *otherMatcher = [ESMatcher just:[SomeComponent class]];

                [[theValue([matcher isEqual:otherMatcher]) should] beYes];
            });


            it(@"should not be equal to another matcher if components are different", ^{
                matcher = [ESMatcher just:[SomeComponent class]];

                ESMatcher *otherMatcher = [ESMatcher just:[SomeOtherComponent class]];

                [[theValue([matcher isEqual:otherMatcher]) should] beNo];
            });

        });

    });

SPEC_END
