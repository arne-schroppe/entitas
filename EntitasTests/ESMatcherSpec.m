#import "ESEntities.h"
#import "Kiwi.h"
#import "SomeComponent.h"
#import "SomeOtherComponent.h"
#import "SomeThirdComponent.h"
#import "ESMatcher.h"
#import "ESEntity+Internal.h"

SPEC_BEGIN(ESMatcherSpec)

	describe(@"ESMatcher", ^{


		__block ESMatcher *matcher;
		__block ESEntities *entities;

		beforeEach(^{
			entities = [ESEntities new];
		});


		context(@"for all component types", ^{

			it(@"should return YES if all component types are present in the entity", ^{

				
				matcher = [ESMatcher allOf:[SomeComponent class], [SomeOtherComponent class], nil];

				ESEntity *entity = [entities createEntity];
				[entity addComponent:[SomeComponent new]];
				[entity addComponent:[SomeOtherComponent new]];

				BOOL isMatching = [matcher areComponentsMatching:[entity componentTypes]];

				[[theValue(isMatching) should] beYes];
			});


			it(@"should return NO if not all component types are present in the entity", ^{

				
				matcher = [ESMatcher allOf:[SomeComponent class], [SomeOtherComponent class], nil];

				ESEntity *entity = [entities createEntity];
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

			it(@"should return YES if any of the components are present", ^{

				
				matcher = [ESMatcher anyOf:[SomeComponent class], [SomeOtherComponent class], nil];

				ESEntity *entity = [entities createEntity];
				[entity addComponent:[SomeComponent new]];

				
				BOOL isMatching = [matcher areComponentsMatching:[entity componentTypes]];

				
				[[theValue(isMatching) should] beYes];

			});


			it(@"should return NO if none of the components are present", ^{

				
				matcher = [ESMatcher anyOf:[SomeComponent class], [SomeOtherComponent class], nil];

				ESEntity *entity = [entities createEntity];
				[entity addComponent:[SomeThirdComponent new]];

				
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

            it(@"should return YES if the component is present", ^{


                matcher = [ESMatcher just:[SomeComponent class]];

                ESEntity *entity = [entities createEntity];
                [entity addComponent:[SomeComponent new]];
                [entity addComponent:[SomeOtherComponent new]];

                BOOL isMatching = [matcher areComponentsMatching:[entity componentTypes]];

                [[theValue(isMatching) should] beYes];

            });


            it(@"should return NO if the components is not present", ^{

                matcher = [ESMatcher just:[SomeComponent class]];

                ESEntity *entity = [entities createEntity];
                [entity addComponent:[SomeOtherComponent new]];

                BOOL isMatching = [matcher areComponentsMatching:[entity componentTypes]];

                [[theValue(isMatching) should] beNo];
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




		context(@"for none of the component types", ^{

			it(@"should return NO if any of the components are present", ^{

				
				matcher = [ESMatcher noneOf:[SomeComponent class], [SomeOtherComponent class], nil];

				ESEntity *entity = [entities createEntity];
				[entity addComponent:[SomeComponent new]];

				
				BOOL isMatching = [matcher areComponentsMatching:[entity componentTypes]];

				
				[[theValue(isMatching) should] beNo];

			});


			it(@"should return YES if none of the components are present", ^{

				
				matcher = [ESMatcher noneOf:[SomeComponent class], [SomeOtherComponent class], nil];

				ESEntity *entity = [entities createEntity];
				[entity addComponent:[SomeThirdComponent new]];

				
				BOOL isMatching = [matcher areComponentsMatching:[entity componentTypes]];

				
				[[theValue(isMatching) should] beYes];

			});




            it(@"should be equal to another matcher of the same type with the same components", ^{

                
                matcher = [ESMatcher noneOf:[SomeComponent class], [SomeOtherComponent class], nil];
                ESMatcher *otherMatcher = [ESMatcher noneOf:[SomeOtherComponent class], [SomeComponent class], nil];

                
                [[theValue([matcher isEqual:otherMatcher]) should] beYes];
                [[theValue(matcher.hash) should] equal:theValue(otherMatcher.hash)];
            });


            it(@"should not be equal to another matcher if the type is different", ^{

                
                matcher = [ESMatcher noneOf:[SomeComponent class], [SomeOtherComponent class], nil];
                ESMatcher *otherMatcher = [ESMatcher anyOf:[SomeOtherComponent class], [SomeComponent class], nil];

                
                [[theValue([matcher isEqual:otherMatcher]) should] beNo];
                [[theValue(matcher.hash) shouldNot] equal:theValue(otherMatcher.hash)];
            });


            it(@"should not be equal to another matcher if components are different", ^{

                
                matcher = [ESMatcher noneOf:[SomeComponent class], nil];
                ESMatcher *otherMatcher = [ESMatcher noneOf:[SomeOtherComponent class], nil];

                
                [[theValue([matcher isEqual:otherMatcher]) should] beNo];

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




                it(@"should be equal to another matcher of the same type with the same components", ^{

                    matcher = [[ESMatcher allOf:[SomeComponent class], nil] and:[ESMatcher allOf:[SomeOtherComponent class], nil]];
                    ESMatcher *otherMatcher = [[ESMatcher allOf:[SomeOtherComponent class], nil] and:[ESMatcher allOf:[SomeComponent class], nil]];

                    [[theValue([matcher isEqual:otherMatcher]) should] beYes];
                    [[theValue(matcher.hash) should] equal:theValue(otherMatcher.hash)];
                });


                it(@"should not be equal to another matcher if the combination is different", ^{

                    matcher = [[ESMatcher allOf:[SomeComponent class], nil] and:[ESMatcher allOf:[SomeOtherComponent class], nil]];
                    ESMatcher *otherMatcher = [[ESMatcher allOf:[SomeOtherComponent class], nil] or:[ESMatcher allOf:[SomeComponent class], nil]];

                    [[theValue([matcher isEqual:otherMatcher]) should] beNo];
                    [[theValue(matcher.hash) shouldNot] equal:theValue(otherMatcher.hash)];
                });


                it(@"should not be equal to another matcher if components are different", ^{

                    matcher = [[ESMatcher allOf:[SomeComponent class], nil] and:[ESMatcher allOf:[SomeOtherComponent class], nil]];
                    ESMatcher *otherMatcher = [[ESMatcher allOf:[SomeThirdComponent class], nil] and:[ESMatcher allOf:[SomeComponent class], nil]];

                    [[theValue([matcher isEqual:otherMatcher]) should] beNo];

                });


                it(@"should combine the component types if its sub matchers", ^{

                    matcher = [[ESMatcher allOf:[SomeComponent class], nil] and:[ESMatcher allOf:[SomeOtherComponent class], nil]];

                    [[matcher.componentTypes should] equal:[NSSet setWithObjects:[SomeComponent class], [SomeOtherComponent class], nil] ];
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


                it(@"should combine the component types if its sub matchers", ^{

                    matcher = [[ESMatcher allOf:[SomeComponent class], nil] or:[ESMatcher allOf:[SomeOtherComponent class], nil]];

                    [[matcher.componentTypes should] equal:[NSSet setWithObjects:[SomeComponent class], [SomeOtherComponent class], nil] ];
                });


                it(@"should be equal to another matcher of the same type with the same components", ^{

                    matcher = [[ESMatcher allOf:[SomeComponent class], nil] or:[ESMatcher allOf:[SomeOtherComponent class], nil]];
                    ESMatcher *otherMatcher = [[ESMatcher allOf:[SomeOtherComponent class], nil] or:[ESMatcher allOf:[SomeComponent class], nil]];

                    [[theValue([matcher isEqual:otherMatcher]) should] beYes];
                    [[theValue(matcher.hash) should] equal:theValue(otherMatcher.hash)];
                });


                it(@"should not be equal to another matcher if the combination is different", ^{

                    matcher = [[ESMatcher allOf:[SomeComponent class], nil] or:[ESMatcher allOf:[SomeOtherComponent class], nil]];
                    ESMatcher *otherMatcher = [[ESMatcher allOf:[SomeOtherComponent class], nil] and:[ESMatcher allOf:[SomeComponent class], nil]];

                    [[theValue([matcher isEqual:otherMatcher]) should] beNo];
                    [[theValue(matcher.hash) shouldNot] equal:theValue(otherMatcher.hash)];
                });


                it(@"should not be equal to another matcher if components are different", ^{

                    matcher = [[ESMatcher allOf:[SomeComponent class], nil] or:[ESMatcher allOf:[SomeOtherComponent class], nil]];
                    ESMatcher *otherMatcher = [[ESMatcher allOf:[SomeThirdComponent class], nil] or:[ESMatcher allOf:[SomeComponent class], nil]];

                    [[theValue([matcher isEqual:otherMatcher]) should] beNo];

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


                it(@"should return the component types of its sub matchers", ^{

                    matcher = [[ESMatcher allOf:[SomeComponent class], [SomeOtherComponent class], nil] not];

                    [[matcher.componentTypes should] equal:[NSSet setWithObjects:[SomeComponent class], [SomeOtherComponent class], nil] ];
                });



                it(@"should be equal to another matcher of the same type with the same components", ^{

                    matcher = [[ESMatcher allOf:[SomeComponent class], [SomeOtherComponent class], nil] not];
                    ESMatcher *otherMatcher = [[ESMatcher allOf:[SomeOtherComponent class], [SomeComponent class], nil] not];

                    [[theValue([matcher isEqual:otherMatcher]) should] beYes];
                    [[theValue(matcher.hash) should] equal:theValue(otherMatcher.hash)];
                });


                it(@"should not be equal to another matcher if the type is different", ^{

                    matcher = [[ESMatcher allOf:[SomeComponent class], [SomeOtherComponent class], nil] not];
                    ESMatcher *otherMatcher = [[ESMatcher anyOf:[SomeOtherComponent class], [SomeComponent class], nil] not];

                    [[theValue([matcher isEqual:otherMatcher]) should] beNo];
                    [[theValue(matcher.hash) shouldNot] equal:theValue(otherMatcher.hash)];
                });


                it(@"should not be equal to another matcher if components are different", ^{

                    matcher = [[ESMatcher allOf:[SomeComponent class], nil] not];
                    ESMatcher *otherMatcher = [[ESMatcher allOf:[SomeOtherComponent class], nil] not];

                    [[theValue([matcher isEqual:otherMatcher]) should] beNo];

                });

			});

        });

	});

SPEC_END
