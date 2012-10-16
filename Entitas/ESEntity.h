#import <Foundation/Foundation.h>
#import "ESComponent.h"

@interface ESEntity : NSObject
- (void)addComponent:(NSObject <ESComponent> *)component;

- (BOOL)containsComponent:(NSObject <ESComponent> *)component;

- (BOOL)hasComponentOfType:(Class)type;

- (void)removeComponentOfType:(Class)type;

- (NSObject <ESComponent> *)getComponentOfType:(Class)type;
@end