#import "Kiwi.h"
#import "ESEntity.h"
#import "SomeComponent.h"
#import "SomeOtherComponent.h"
#import "ESEntities.h"

registerMatcher(NSNotificationMatcher)

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
            [[entity should] beKindOfClass:[ESEntity class]];
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
            [[theValue([entity hasComponentsOfTypes:[NSSet setWithObject:[SomeComponent class]]]) should] equal:theValue(NO)];
        });

        it(@"should not have components of types when not all components of these types were added", ^{
            NSSet *types = [NSSet setWithObjects:[SomeComponent class], [SomeOtherComponent class], nil];
            [entity addComponent:component];
            [[theValue([entity hasComponentsOfTypes:types]) should] equal:theValue(NO)];
        });

        it(@"should have components of types when all components of these types were added", ^{
            NSSet *types = [NSSet setWithObjects:[SomeComponent class], [SomeOtherComponent class], nil];
            [entity addComponent:component];
            [entity addComponent:[[SomeOtherComponent alloc] init]];
            [[theValue([entity hasComponentsOfTypes:types]) should] equal:theValue(YES)];
        });

        it(@"should remove a component of type", ^{
            [entity addComponent:component];
            [entity removeComponentOfType:[SomeComponent class]];
            [[theValue([entity containsComponent:component]) should] equal:theValue(NO)];
        });

        it(@"should get a component by its type", ^{
            [entity addComponent:component];
            [[[entity componentOfType:[SomeComponent class]] should] equal:component];
        });

        it(@"should raise an exception when adding a component of the same type twice", ^{
            [[theBlock(^{
                [entity addComponent:component];
                [entity addComponent:component];
            }) should] raiseWithName:@"An entity cannot contain multiple components of the same type."];
        });

        it(@"should call ESEntities object that a component has been added to this entity", ^{
            ESEntities *entities = [[ESEntities alloc] init];
            entity.entities = entities;
            [[[entities should] receive] component:component ofType:[component class] hasBeenAddedToEntity:entity];
            [entity addComponent:component];
        });

        it(@"should call ESEntities object that a component has been removed from this entity", ^{
            ESEntities *entities = [[ESEntities alloc] init];
            entity.entities = entities;
            [[[entities should] receive] component:component ofType:[component class] hasBeenRemovedFromEntity:entity];
            [entity addComponent:component];
            [entity removeComponentOfType:[component class]];
        });

        it(@"should not call ESEntities object that a component has been removed from this entity if it didn't contain a component of that type", ^{
            ESEntities *entities = [[ESEntities alloc] init];
            entity.entities = entities;
            [[[entities shouldNot] receive] component:nil ofType:[component class] hasBeenRemovedFromEntity:entity];
            [entity removeComponentOfType:[component class]];
        });

        it(@"should not have a component of type when a component of that has been removed", ^{
            [entity addComponent:component];
            [entity removeComponentOfType:[component class]];
            [[theValue([entity hasComponentOfType:[component class]]) should] equal:theValue(NO)];
        });


        it(@"should exchange a component", ^{
            [entity addComponent:component];
            [entity exchangeComponent:[[SomeComponent alloc] initWithValue:1]];

            SomeComponent *exchangedComponent = (SomeComponent *) [entity componentOfType:[SomeComponent class]];
            [[theValue(exchangedComponent.value) should] equal:theValue(1)];
        });

        it(@"should have a component of type when component of that type was exchanged", ^{
            [entity exchangeComponent:component];
            [[theValue([entity hasComponentOfType:[SomeComponent class]]) should] equal:theValue(YES)];
        });

        it(@"should call ESEntities object that a component has been exchanged for this entity", ^{
            ESEntities *entities = [[ESEntities alloc] init];
            entity.entities = entities;
            [[[entities should] receive] component:component ofType:[component class] hasBeenExchangedInEntity:entity];
            [entity exchangeComponent:component];
            [entity removeComponentOfType:[component class]];
        });
    });

SPEC_END