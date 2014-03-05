#import "Kiwi.h"
#import "SomeComponent.h"
#import "SomeOtherComponent.h"
#import "ESReactiveSystem.h"
#import "ESReactiveSubSystem.h"
#import "ESReactiveSubSystem4.h"
#import "ESReactiveSystem4.h"
#import "ESReactiveSubSystem5.h"
#import "ESReactiveSystemSettings.h"
#import "ESReactiveSystem5.h"


@interface PrintString : NSObject<ESReactiveSubSystem>

@end


@implementation PrintString

- (void)executeWithEntities:(NSArray *)entities {
    NSLog(@"Hello, Version 1!");
}


- (ESMatcher *)triggeringComponents {
    return [ESMatcher allOf:[SomeComponent class], [SomeOtherComponent class], nil];
}


- (ESMatcher *)mandatoryComponents {
    return [ESMatcher allOf:[SomeComponent class], nil];
}

@end






@interface PrintString4 : NSObject<ESReactiveSubSystem4>

@end

@implementation PrintString4

- (void)executeWithEntities:(NSArray *)entities {
    NSLog(@"Hello, Version 4!");
}


- (ESEntityChange)notificationType {
    return ESEntityAdded;
}


- (ESMatcher *)triggeringComponents {
    return [ESMatcher allOf:[SomeComponent class], [SomeOtherComponent class], nil];
}


- (ESMatcher *)mandatoryComponents {
    return [ESMatcher allOf:[SomeComponent class], nil];
}

@end






@interface PrintString5 : NSObject<ESReactiveSubSystem5>

@end

@implementation PrintString5

- (void)setUp:(ESReactiveSystemSettings *)settings {
    settings.triggeringComponents = [ESMatcher allOf:[SomeComponent class], [SomeOtherComponent class], nil];
    settings.mandatoryComponents = [ESMatcher allOf:[SomeComponent class], nil];
    settings.changeType = ESEntityAdded;
}


- (void)executeWithEntities:(NSArray *)entities {
    NSLog(@"Hello, Version 5!");
}


@end




SPEC_BEGIN(ReactiveSystemExamples)

describe(@"Reactive system creation", ^{


    it(@"Version 1: Classic", ^{

        ESEntityRepository *repo = [[ESEntityRepository alloc] init];
        ESReactiveSystem *system = [[ESReactiveSystem alloc] initWithSystem:[PrintString new]
                                                           entityRepository:repo
                                                           notificationType:ESEntityAdded];

        for (int i=0; i < 4; ++i) {
            [system execute];

            ESEntity *entity = [repo createEntity];
            [entity addComponent:[SomeComponent new]];
            [entity addComponent:[SomeOtherComponent new]];
        }

    });


    //version 2 and 3 deleted


    it(@"Version 4: All inclusive", ^{

        ESEntityRepository *repo = [[ESEntityRepository alloc] init];
        ESReactiveSystem4 *system = [[ESReactiveSystem4 alloc] initWithSystem:[PrintString4 new]
                                                             entityRepository:repo];

        for (int i=0; i < 4; ++i) {
            [system execute];

            ESEntity *entity = [repo createEntity];
            [entity addComponent:[SomeComponent new]];
            [entity addComponent:[SomeOtherComponent new]];
        }

    });


    it(@"Version 5: All inclusive with settings method", ^{

        ESEntityRepository *repo = [[ESEntityRepository alloc] init];
        ESReactiveSystem5 *system = [[ESReactiveSystem5 alloc] initWithSystem:[PrintString5 new]
                                                             entityRepository:repo];

        for (int i=0; i < 4; ++i) {
            [system execute];

            ESEntity *entity = [repo createEntity];
            [entity addComponent:[SomeComponent new]];
            [entity addComponent:[SomeOtherComponent new]];
        }

    });


});


SPEC_END