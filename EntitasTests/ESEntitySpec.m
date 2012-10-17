#import "Kiwi.h"
#import "ESEntity.h"
#import "ESComponent.h"
#import "SomeComponent.h"
#import "SomeOtherComponent.h"

SPEC_BEGIN(ESEntitySpec)

        describe(@"ESEntity", ^{

            __block ESEntity *entity = nil;
            __block SomeComponent *component = nil;

            beforeEach(^{
                entity = [[ESEntity alloc] init];
                component = [[SomeComponent alloc] init];
            });

            it(@"should be instantiated", ^{
                [entity shouldNotBeNil];
                [[entity should] beKindOfClass: [ESEntity class]];
            });

            it(@"should add a component", ^{
                [entity addComponent:component];
                [[theValue([entity containsComponent:component]) should] equal:theValue(YES)];
            });

            it(@"should not contain a component which hasn't been added", ^{
                [[theValue([entity containsComponent:component]) should] equal:theValue(NO)];
            });

            it(@"should have a component of type when component of that type was added", ^{
                [entity addComponent:component];
                [[theValue([entity hasComponentOfType:[SomeComponent class]]) should] equal:theValue(YES)];
            });

            it(@"should not have a component of type when no component of that type was added", ^{
                [[theValue([entity hasComponentOfType:[SomeComponent class]]) should] equal:theValue(NO)];
            });

            it(@"should not have components of types when no components of these types were added", ^{
                [[theValue([entity hasComponentsOfTypes:@[[SomeComponent class]]]) should] equal:theValue(NO)];
            });

            it(@"should not have components of types when not all components of these types were added", ^{
                NSArray *types = @[[SomeComponent class], [SomeOtherComponent class]];
                [entity addComponent:component];
                [[theValue([entity hasComponentsOfTypes:types]) should] equal:theValue(NO)];
            });

            it(@"should have components of types when all components of these types were added", ^{
                NSArray *types = @[[SomeComponent class], [SomeOtherComponent class]];
                [entity addComponent:component];
                [entity addComponent:[[SomeOtherComponent alloc] init] ];
                [[theValue([entity hasComponentsOfTypes:types]) should] equal:theValue(YES)];
            });

            it(@"should remove a component of type", ^{
                [entity addComponent:component];
                [entity removeComponentOfType:[SomeComponent class]];
                [[theValue([entity containsComponent:component]) should] equal:theValue(NO)];
            });

            it(@"should get a component by its type", ^{
                [entity addComponent:component];
                [[[entity getComponentOfType:[SomeComponent class]] should] equal:component];
            });

            it(@"should raise an exception when adding a component of the same type twice", ^{
                [[theBlock(^{
                    [entity addComponent:component];
                    [entity addComponent:component];
                }) should] raiseWithName:@"An entity cannot contain multiple components of the same type."];
            });

        });

SPEC_END