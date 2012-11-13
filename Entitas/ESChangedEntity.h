#import <Foundation/Foundation.h>
#import "ESEntity.h"

@interface ESChangedEntity : NSObject
- (id)initWithOriginalEntity:(ESEntity *)originalEntity ChangedComponents:(NSArray *)changedComponents;

- (ESEntity *)getOriginalEntity;

- (NSObject <ESComponent> *)getComponentOfType:(Class)type;
@end