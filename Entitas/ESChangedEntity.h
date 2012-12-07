#import <Foundation/Foundation.h>
#import "ESEntity.h"

enum
{
    ESEntityAddedToCollection = 1,
    ESEntityRemovedFromCollection = 2
};
typedef NSUInteger ESEntityChange;

@interface ESChangedEntity : NSObject
- (id)initWithOriginalEntity:(ESEntity *)originalEntity Components:(NSDictionary *)components ChangeType:(ESEntityChange)changeType;

- (ESEntity *)getOriginalEntity;

- (NSObject <ESComponent> *)getComponentOfType:(Class)type;

- (ESEntityChange)changeType;
@end