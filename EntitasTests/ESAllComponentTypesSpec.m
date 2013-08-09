#import <Entitas/ESEntities.h>
#import "Kiwi.h"
#import "ESAllComponentTypes.h"
#import "ESAnyComponentTypes.h"
#import "SomeComponent.h"
#import "SomeOtherComponent.h"

SPEC_BEGIN(ESAllComponentTypesSpec)

describe(@"ESAllComponentTypes", ^{


    __block ESAllComponentTypes *allComponentTypes;
    __block ESEntities *entities;

    beforeEach(^{
        entities = [ESEntities new];
    });


    it(@"should return YES if all component types are present in the entity", ^{

        // given
        allComponentTypes = [[ESAllComponentTypes alloc] initWithClasses:[SomeComponent class], [SomeOtherComponent class], nil];

        ESEntity *entity = [entities createEntity];
        [entity addComponent:[SomeComponent new]];
        [entity addComponent:[SomeOtherComponent new]];

        // when
        BOOL isMatching = [allComponentTypes areComponentsMatching:[entity componentTypes]];

        // then
        [[theValue(isMatching) should] beYes];
    });


    it(@"should return NO if not all component types are present in the entity", ^{

        // given
        allComponentTypes = [[ESAllComponentTypes alloc] initWithClasses:[SomeComponent class], [SomeOtherComponent class], nil];

        ESEntity *entity = [entities createEntity];
        [entity addComponent:[SomeComponent new]];

        // when
        BOOL isMatching = [allComponentTypes areComponentsMatching:[entity componentTypes]];

        // then
        [[theValue(isMatching) should] beNo];
    });


    context(@"when testing equality", ^{


        it(@"should be equal to another matcher of the same type with the same components", ^{

            // given
            allComponentTypes = [[ESAllComponentTypes alloc] initWithClasses:[SomeComponent class], [SomeOtherComponent class], nil];
            NSObject<ESComponentMatcher> *otherMatcher = [[ESAllComponentTypes alloc] initWithClasses:[SomeOtherComponent class], [SomeComponent class], nil];

            // then
            [[theValue([allComponentTypes isEqual:otherMatcher]) should] beYes];
            [[theValue(allComponentTypes.hash) should] equal:theValue(otherMatcher.hash)];
        });


        it(@"should not be equal to another matcher if the type is different", ^{

            // given
            allComponentTypes = [[ESAllComponentTypes alloc] initWithClasses:[SomeComponent class], [SomeOtherComponent class], nil];
            NSObject<ESComponentMatcher> *otherMatcher = [[ESAnyComponentTypes alloc] initWithClasses:[SomeOtherComponent class], [SomeComponent class], nil];

            // then
            [[theValue([allComponentTypes isEqual:otherMatcher]) should] beNo];
            [[theValue(allComponentTypes.hash) shouldNot] equal:theValue(otherMatcher.hash)];
        });


        it(@"should not be equal to another matcher if components are different", ^{

            // given
            allComponentTypes = [[ESAllComponentTypes alloc] initWithClasses:[SomeComponent class], nil];
            NSObject<ESComponentMatcher> *otherMatcher = [[ESAllComponentTypes alloc] initWithClasses:[SomeOtherComponent class], nil];

            // then
            [[theValue([allComponentTypes isEqual:otherMatcher]) should] beNo];
            //[[theValue(allComponentTypes.hash) shouldNot] equal:theValue(otherMatcher.hash)];

        });

    });

});

SPEC_END
