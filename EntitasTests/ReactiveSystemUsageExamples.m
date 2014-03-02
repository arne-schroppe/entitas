#import "Kiwi.h"
#import "ESReactiveSystem2.h"
#import "SomeComponent.h"
#import "SomeOtherComponent.h"
#import "ESReactiveSystem.h"
#import "ESReactiveSubSystem.h"
#import "ESReactiveSubSystem3.h"
#import "ESReactiveSystem3.h"


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





@interface PrintString3 : NSObject<ESReactiveSubSystem3>

@end

@implementation PrintString3

- (void)executeWithEntities:(NSArray *)entities {
	NSLog(@"Hello, Version 3!");
}

@end




SPEC_BEGIN(ReactiveSystemExamples)

describe(@"Reactive system creation", ^{


	it(@"Version 1", ^{

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



	it(@"Version 2", ^{

		ESEntityRepository *repo = [[ESEntityRepository alloc] init];
		ESReactiveSystem2 *system = [[ESReactiveSystem2 alloc] initWithEntityRepository:repo
																	   notificationType:ESEntityAdded
																			   triggers:[ESMatcher allOf:
																					      [SomeComponent class],
																						  [SomeOtherComponent class],
																						   nil]
																		   executeBlock:^(NSArray *array) {
																			   NSLog(@"Hello, Version 2!");
																		   }];
		system.mandatoryComponents = [ESMatcher allOf:[SomeComponent class], nil];


		for (int i=0; i < 4; ++i) {
			[system execute];

			ESEntity *entity = [repo createEntity];
			[entity addComponent:[SomeComponent new]];
			[entity addComponent:[SomeOtherComponent new]];
		}

	});




	it(@"Version 3", ^{

		ESEntityRepository *repo = [[ESEntityRepository alloc] init];
		ESReactiveSystem3 *system = [[ESReactiveSystem3 alloc] initWithEntityRepository:repo
																			  subSystem:[PrintString3 new]
																	   notificationType:ESEntityAdded
																			   triggers:[ESMatcher allOf:
																					      [SomeComponent class],
																					      [SomeOtherComponent class],
																					       nil]];
		system.mandatoryComponents = [ESMatcher allOf:[SomeComponent class], nil];


		for (int i=0; i < 4; ++i) {
			[system execute];

			ESEntity *entity = [repo createEntity];
			[entity addComponent:[SomeComponent new]];
			[entity addComponent:[SomeOtherComponent new]];
		}

	});


});


SPEC_END