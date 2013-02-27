#import <Foundation/Foundation.h>
#import "ESEntity.h"

typedef NS_ENUM(NSUInteger, ESEntityChange) {
    ESEntityAddedToCollection,
    ESEntityRemovedFromCollection
};

@interface ESChangedEntity : NSObject
- (id)initWithOriginalEntity:(ESEntity *)originalEntity components:(NSDictionary *)components changeType:(ESEntityChange)changeType;
- (ESEntity *)originalEntity;
- (NSObject <ESComponent> *)componentOfType:(Class)type;
- (ESEntityChange)changeType;
@end