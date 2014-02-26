#import <Foundation/Foundation.h>


@class ESMatcher;
@class ESEntity;


@interface ESEntityRepository : NSObject

- (ESEntity *)createEntity;

- (void)destroyEntity:(ESEntity *)entity;

- (BOOL)containsEntity:(ESEntity *)entity;

- (NSArray *)allEntities;

- (NSArray *)entitiesForType:(Class)type;

- (NSArray *)entitiesForTypes:(NSSet *)types;

- (NSArray *)entitiesForMatcher:(ESMatcher *)matcher;

@end