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

                //TODO (asc 15/8/13) Also test hash and equality of combined matchers!

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


		context(@"for none of the component types", ^{

			it(@"should return NO if any of the components are present", ^{

				// given
				matcher = [ESMatcher noneOf:[SomeComponent class], [SomeOtherComponent class], nil];

				ESEntity *entity = [entities createEntity];
				[entity addComponent:[SomeComponent new]];

				// when
				BOOL isMatching = [matcher areComponentsMatching:[entity componentTypes]];

				// then
				[[theValue(isMatching) should] beNo];

			});


			it(@"should return YES if none of the components are present", ^{

				// given
				matcher = [ESMatcher noneOf:[SomeComponent class], [SomeOtherComponent class], nil];

				ESEntity *entity = [entities createEntity];
				[entity addComponent:[SomeThirdComponent new]];

				// when
				BOOL isMatching = [matcher areComponentsMatching:[entity componentTypes]];

				// then
				[[theValue(isMatching) should] beYes];

			});

		});


        context(@"for matcher combinators", ^{

            __block ESMatcher *combinedMatcher;
            __block NSSet *componentTypes;
            __block ESMatcher *matchingMatcher;
            __block ESMatcher *nonMatchingMatcher;

            beforeEach(^{
                componentTypes = [NSSet setWithObjects:[SomeComponent class], [SomeOtherComponent class], nil];

                matchingMatcher = [ESMatcher allOf:[SomeComponent class], [SomeOtherComponent class], nil];
                nonMatchingMatcher = [ESMatcher allOf:[SomeThirdComponent class], nil];
            });


            context(@"for AND combined matchers", ^{

                it(@"should match if all sub-matchers match", ^{

                    combinedMatcher = [matchingMatcher and:matchingMatcher];

                    BOOL isMatching = [combinedMatcher areComponentsMatching:componentTypes];

                    [[theValue(isMatching) should] beYes];
                });


                it(@"should not match if first sub-matcher does not match", ^{

                    combinedMatcher = [nonMatchingMatcher and:matchingMatcher];

                    BOOL isMatching = [combinedMatcher areComponentsMatching:componentTypes];

                    [[theValue(isMatching) should] beNo];
                });


                it(@"should not match if second sub-matcher does not match", ^{

                    combinedMatcher = [matchingMatcher and:nonMatchingMatcher];

                    BOOL isMatching = [combinedMatcher areComponentsMatching:componentTypes];

                    [[theValue(isMatching) should] beNo];
                });


                it(@"should not match if no sub-matcher matches", ^{

                    combinedMatcher = [nonMatchingMatcher and:nonMatchingMatcher];

                    BOOL isMatching = [combinedMatcher areComponentsMatching:componentTypes];

                    [[theValue(isMatching) should] beNo];
                });

            });


            context(@"for OR-combined matchers", ^{


                it(@"should match if all sub-matchers match", ^{

                    combinedMatcher = [matchingMatcher or:matchingMatcher];

                    BOOL isMatching = [combinedMatcher areComponentsMatching:componentTypes];

                    [[theValue(isMatching) should] beYes];
                });


                it(@"should match if first sub-matcher does not match", ^{

                    combinedMatcher = [nonMatchingMatcher or:matchingMatcher];

                    BOOL isMatching = [combinedMatcher areComponentsMatching:componentTypes];

                    [[theValue(isMatching) should] beYes];
                });

                it(@"should match if second sub-matcher does not match", ^{

                    combinedMatcher = [matchingMatcher or:nonMatchingMatcher];

                    BOOL isMatching = [combinedMatcher areComponentsMatching:componentTypes];

                    [[theValue(isMatching) should] beYes];
                });


                it(@"should not match if no sub-matcher matches", ^{

                    combinedMatcher = [nonMatchingMatcher or:nonMatchingMatcher];

                    BOOL isMatching = [combinedMatcher areComponentsMatching:componentTypes];

                    [[theValue(isMatching) should] beNo];
                });

            });


			context(@"for NOT-matcher", ^{

				it(@"should match if its sub-matcher doesn't", ^{

					combinedMatcher = [nonMatchingMatcher not];

					BOOL isMatching = [combinedMatcher areComponentsMatching:componentTypes];

					[[theValue(isMatching) should] beYes];
				});


				it(@"should not match if its sub-matcher does", ^{

					combinedMatcher = [matchingMatcher not];

					BOOL isMatching = [combinedMatcher areComponentsMatching:componentTypes];

					[[theValue(isMatching) should] beNo];
				});

			});

        });

	});

SPEC_END
