#import <Foundation/Foundation.h>
#import "ESEntity.h"
#import "ESCollection.h"

@interface ESCollection()
- (id)initWithTypes:(NSSet *)types;
- (id)initWithMatcher:(ESMatcher *)matcher;
- (ESMatcher *)typeMatcher;
- (void)addEntity:(ESChangedEntity *)changedEntity;
- (void)removeEntity:(ESChangedEntity *)changedEntity;
- (NSArray *)entities;
- (void)addObserver:(id <ESCollectionObserver>)observer forEvent:(ESEntityChange)event;
- (void)removeObserver:(id <ESCollectionObserver>)observer forEvent:(ESEntityChange)event;
- (void)remove:(ESChangedEntity *)removedEntity andAddEntity:(ESChangedEntity *)addedEntity;
@end

