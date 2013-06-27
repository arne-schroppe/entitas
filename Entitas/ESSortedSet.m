#import "ESSortedSet.h"
#import "ESEntity.h"


@implementation ESSortedSet {
    NSMutableArray *_data;
}

- (id) init {
    self = [super init];
    if (self) {
        _data = [[NSMutableArray alloc] init];
    }

    return self;
}

NSComparisonResult (^idComparator)(ESEntity *, ESEntity *) = ^NSComparisonResult(ESEntity *entity1, ESEntity *entity2) {
    NSNumber *id1 = @(entity1.id);
    NSNumber *id2 = @(entity2.id);
    return [id1 compare:id2];
};

- (void) addObject:(id)object {
    if(![_data containsObject:object]) {
        [_data addObject:object];
        [_data sortUsingComparator:idComparator];
    }
}

- (void) removeObject:(id)object {
    [_data removeObject:object];
}

- (BOOL) containsObject:(id)anObject {
    return [_data containsObject:anObject];
}

- (id) anyObject {
    return _data[0];
}

- (NSArray *) allObjects {
    return [_data copy];
}

- (id)copy {
    return [_data copy];
}

- (NSUInteger) countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained [])buffer count:(NSUInteger)len {
    return [_data countByEnumeratingWithState:state objects:buffer count:len];
}

- (NSUInteger) count {
    return [_data count];
}


@end