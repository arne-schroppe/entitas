#import <Entitas/ESEntities.h>
#import "Kiwi.h"
#import "SomeComponent.h"
#import "SomeOtherComponent.h"
#import "ESMatcher.h"
#import "SomeThirdComponent.h"

SPEC_BEGIN(ESMatcherSpec)

	describe(@"ESMatcher", ^{


		__block ESMatcher *matcher;
		__block ESEntities *entities;

		beforeEach(^{
			entities = [ESEntities new];
		});


		context(@"for all component types", ^{

			it(@"should return YES if all component types are present in the entity", ^{

				// given
				matcher = [ESMatcher allOf:[SomeComponent class], [SomeOtherComponent class], nil];

				ESEntity *entity = [entities createEntity];
				[entity addComponent:[SomeComponent new]];
				[entity addComponent:[SomeOtherComponent new]];

				// when
				BOOL isMatching = [matcher areComponentsMatching:[entity componentTypes]];

				// then
				[[theValue(isMatching) should] beYes];
			});


			it(@"should return NO if not all component types are present in the entity", ^{

				// given
				matcher = [ESMatcher allOf:[SomeComponent class], [SomeOtherComponent class], nil];

				ESEntity *entity = [entities createEntity];
				[entity addComponent:[SomeComponent new]];

				// when
				BOOL isMatching = [matcher areComponentsMatching:[entity componentTypes]];

				// then
				[[theValue(isMatching) should] beNo];
			});


			context(@"when testing equality", ^{


				it(@"should be equal to another matcher of the same type with the same components", ^{

					// given
					matcher = [ESMatcher allOf:[SomeComponent class], [SomeOtherComponent class], nil];
					ESMatcher *otherMatcher = [ESMatcher allOf:[SomeOtherComponent class], [SomeComponent class], nil];

					// then
					[[theValue([matcher isEqual:otherMatcher]) should] beYes];
					[[theValue(matcher.hash) should] equal:theValue(otherMatcher.hash)];
				});


				it(@"should not be equal to another matcher if the type is different", ^{

					// given
					matcher = [ESMatcher allOf:[SomeComponent class], [SomeOtherComponent class], nil];
					ESMatcher *otherMatcher = [ESMatcher anyOf:[SomeOtherComponent class], [SomeComponent class], nil];

					// then
					[[theValue([matcher isEqual:otherMatcher]) should] beNo];
					[[theValue(matcher.hash) shouldNot] equal:theValue(otherMatcher.hash)];
				});


				it(@"should not be equal to another matcher if components are different", ^{

					// given
					matcher = [ESMatcher allOf:[SomeComponent class], nil];
					ESMatcher *otherMatcher = [ESMatcher allOf:[SomeOtherComponent class], nil];

					// then
					[[theValue([matcher isEqual:otherMatcher]) should] beNo];
					//[[theValue(matcher.hash) shouldNot] equal:theValue(otherMatcher.hash)];

				});

			});


		});




		context(@"for any component types", ^{

			it(@"should return YES if any of the components are present", ^{

				// given
				matcher = [ESMatcher anyOf:[SomeComponent class], [SomeOtherComponent class], nil];

				ESEntity *entity = [entities createEntity];
				[entity addComponent:[SomeComponent new]];

				// when
				BOOL isMatching = [matcher areComponentsMatching:[entity componentTypes]];

				// then
				[[theValue(isMatching) should] beYes];

			});


			it(@"should return NO if none of the components are present", ^{

				// given
				matcher = [ESMatcher anyOf:[SomeComponent class], [SomeOtherComponent class], nil];

				ESEntity *entity = [entities createEntity];
				[entity addComponent:[SomeThirdComponent new]];

				// when
				BOOL isMatching = [matcher areComponentsMatching:[entity componentTypes]];

				// then
				[[theValue(isMatching) should] beNo];

			});




			it(@"should be equal to another matcher of the same type with the same components", ^{

				// given
				matcher = [ESMatcher anyOf:[SomeComponent class], [SomeOtherComponent class], nil];
				ESMatcher *otherMatcher = [ESMatcher anyOf:[SomeOtherComponent class], [SomeComponent class], nil];

				// then
				[[theValue([matcher isEqual:otherMatcher]) should] beYes];
			});


			it(@"should not be equal to another matcher if the type is different", ^{

				// given
				matcher = [ESMatcher anyOf:[SomeComponent class], [SomeOtherComponent class], nil];
				ESMatcher *otherMatcher = [ESMatcher allOf:[SomeOtherComponent class], [SomeComponent class], nil];

				// then
				[[theValue([matcher isEqual:otherMatcher]) should] beNo];
			});


			it(@"should not be equal to another matcher if components are different", ^{

				// given
				matcher = [ESMatcher anyOf:[SomeComponent class], nil];
				ESMatcher *otherMatcher = [ESMatcher anyOf:[SomeOtherComponent class], nil];

				// then
				[[theValue([matcher isEqual:otherMatcher]) should] beNo];

			});

		});


	});

SPEC_END
