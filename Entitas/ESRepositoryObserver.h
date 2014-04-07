#import <Foundation/Foundation.h>
#import "ESCollection.h"

@class ESMatcher;
@class ESEntityRepository;


@protocol ESEntityRepositoryDelegate

- (void)executeWithEntities:(NSArray *)entities;

@end


@interface ESRepositoryObserver : NSObject

- (id)initWithRepository:(ESEntityRepository *)repository matcher:(ESMatcher *)matcher target:(id<ESEntityRepositoryDelegate>)target;
- (id)initWithRepository:(ESEntityRepository *)repository matcher:(ESMatcher *)matcher target:(id<ESEntityRepositoryDelegate>)target trigger:(ESEntityChange)changeTrigger;

- (void)executeWithCollectedEntities;

- (void)deactivate;
- (void)activate;

@end
