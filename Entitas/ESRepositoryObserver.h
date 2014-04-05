#import <Foundation/Foundation.h>
#import "ESCollection.h"

@class ESMatcher;
@class ESEntityRepository;


@interface ESRepositoryObserver : NSObject

- (id)initWithRepository:(ESEntityRepository *)repository matcher:(ESMatcher *)matcher target:(id)target;
- (id)initWithRepository:(ESEntityRepository *)repository matcher:(ESMatcher *)matcher target:(id)target trigger:(ESEntityChange)changeTrigger;

- (void)executeWithCollectedEntities;

- (void)deactivate;
- (void)activate;

@end