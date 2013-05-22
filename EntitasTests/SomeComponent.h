#import <Foundation/Foundation.h>
#import "ESComponent.h"

@interface SomeComponent : NSObject <ESComponent>


@property NSInteger value;

- (id)initWithValue:(NSInteger)value;


@end