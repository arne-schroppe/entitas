#import <Foundation/Foundation.h>

@class ESMatcher;
@class ESEntityRepository;


@interface ESRepositoryObserver : NSObject

- (id)initWithRepository:(ESEntityRepository *)repository matcher:(ESMatcher *)matcher target:(id)target;

- (void)executeWithCollectedEntities;
@end