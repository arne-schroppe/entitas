#import <Entitas/ESEntities.h>
#import "Kiwi.h"
#import "ESAnyComponentType.h"
#import "SomeComponent.h"
#import "SomeOtherComponent.h"
#import "ESAllComponentTypes.h"
#import "SomeThirdComponent.h"

SPEC_BEGIN(ESAnyComponentTypeSpec)

describe(@"ESAnyComponentType", ^{

    __block ESAnyComponentType *anyComponentType;
    __block ESEntities *entities;

    beforeEach(^{

        entities = [ESEntities new];

    });

    it(@"should return YES if any of the components are present", ^{

        // given
        anyComponentType = [[ESAnyComponentType alloc] initWithClasses:[SomeComponent class], [SomeOtherComponent class], nil];

        ESEntity *entity = [entities createEntity];
        [entity addComponent:[SomeComponent new]];

        // when
        BOOL isMatching = [anyComponentType isEntityMatching:entity];

        // then
        [[theValue(isMatching) should] beYes];

    });


    it(@"should return NO if none of the components are present", ^{

        // given
        anyComponentType = [[ESAnyComponentType alloc] initWithClasses:[SomeComponent class], [SomeOtherComponent class], nil];

        ESEntity *entity = [entities createEntity];
        [entity addComponent:[SomeThirdComponent new]];

        // when
        BOOL isMatching = [anyComponentType isEntityMatching:entity];

        // then
        [[theValue(isMatching) should] beNo];

    });




    it(@"should be equal to another matcher of the same type with the same components", ^{

        // given
        anyComponentType = [[ESAnyComponentType alloc] initWithClasses:[SomeComponent class], [SomeOtherComponent class], nil];
        NSObject<ESComponentMatcher> *otherMatcher = [[ESAnyComponentType alloc] initWithClasses:[SomeOtherComponent class], [SomeComponent class], nil];

        // then
        [[theValue([anyComponentType isEqual:otherMatcher]) should] beYes];
    });


    it(@"should not be equal to another matcher if the type is different", ^{

        // given
        anyComponentType = [[ESAnyComponentType alloc] initWithClasses:[SomeComponent class], [SomeOtherComponent class], nil];
        NSObject<ESComponentMatcher> *otherMatcher = [[ESAllComponentTypes alloc] initWithClasses:[SomeOtherComponent class], [SomeComponent class], nil];

        // then
        [[theValue([anyComponentType isEqual:otherMatcher]) should] beNo];
    });


    it(@"should not be equal to another matcher if components are different", ^{

        // given
        anyComponentType = [[ESAnyComponentType alloc] initWithClasses:[SomeComponent class], nil];
        NSObject<ESComponentMatcher> *otherMatcher = [[ESAnyComponentType alloc] initWithClasses:[SomeOtherComponent class], nil];

        // then
        [[theValue([anyComponentType isEqual:otherMatcher]) should] beNo];

    });
      
});

SPEC_END
