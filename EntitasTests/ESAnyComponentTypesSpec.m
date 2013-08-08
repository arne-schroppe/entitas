#import <Entitas/ESEntities.h>
#import "Kiwi.h"
#import "ESAnyComponentTypes.h"
#import "SomeComponent.h"
#import "SomeOtherComponent.h"
#import "ESAllComponentTypes.h"
#import "SomeThirdComponent.h"

SPEC_BEGIN(ESAnyComponentTypesSpec)

describe(@"ESAnyComponentTypes", ^{

    __block ESAnyComponentTypes *anyComponentType;
    __block ESEntities *entities;

    beforeEach(^{

        entities = [ESEntities new];

    });

    it(@"should return YES if any of the components are present", ^{

        // given
        anyComponentType = [[ESAnyComponentTypes alloc] initWithClasses:[SomeComponent class], [SomeOtherComponent class], nil];

        ESEntity *entity = [entities createEntity];
        [entity addComponent:[SomeComponent new]];

        // when
        BOOL isMatching = [anyComponentType areComponentsMatching:[entity componentTypes]];

        // then
        [[theValue(isMatching) should] beYes];

    });


    it(@"should return NO if none of the components are present", ^{

        // given
        anyComponentType = [[ESAnyComponentTypes alloc] initWithClasses:[SomeComponent class], [SomeOtherComponent class], nil];

        ESEntity *entity = [entities createEntity];
        [entity addComponent:[SomeThirdComponent new]];

        // when
        BOOL isMatching = [anyComponentType areComponentsMatching:[entity componentTypes]];

        // then
        [[theValue(isMatching) should] beNo];

    });




    it(@"should be equal to another matcher of the same type with the same components", ^{

        // given
        anyComponentType = [[ESAnyComponentTypes alloc] initWithClasses:[SomeComponent class], [SomeOtherComponent class], nil];
        NSObject<ESComponentMatcher> *otherMatcher = [[ESAnyComponentTypes alloc] initWithClasses:[SomeOtherComponent class], [SomeComponent class], nil];

        // then
        [[theValue([anyComponentType isEqual:otherMatcher]) should] beYes];
    });


    it(@"should not be equal to another matcher if the type is different", ^{

        // given
        anyComponentType = [[ESAnyComponentTypes alloc] initWithClasses:[SomeComponent class], [SomeOtherComponent class], nil];
        NSObject<ESComponentMatcher> *otherMatcher = [[ESAllComponentTypes alloc] initWithClasses:[SomeOtherComponent class], [SomeComponent class], nil];

        // then
        [[theValue([anyComponentType isEqual:otherMatcher]) should] beNo];
    });


    it(@"should not be equal to another matcher if components are different", ^{

        // given
        anyComponentType = [[ESAnyComponentTypes alloc] initWithClasses:[SomeComponent class], nil];
        NSObject<ESComponentMatcher> *otherMatcher = [[ESAnyComponentTypes alloc] initWithClasses:[SomeOtherComponent class], nil];

        // then
        [[theValue([anyComponentType isEqual:otherMatcher]) should] beNo];

    });
      
});

SPEC_END
