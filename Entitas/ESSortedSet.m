#import "ESSortedSet.h"
#import "ESEntity.h"


@implementation ESSortedSet {
    NSMutableArray *_data;
}

- (id) initWithData:(NSMutableArray *)data {
    self = [super init];
    if (self) {
        _data = data;
    }

    return self;
}

- (id)init {
    return [self initWithData:[[NSMutableArray alloc] init]];
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
    if(_data.count < 1) {
        return nil;
    }
    return _data[0];
}

- (NSArray *) allObjects {
    return [_data copy];
}

- (id)copy {
    return [[ESSortedSet alloc] initWithData:[_data mutableCopy]];
}

- (NSUInteger) countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained [])buffer count:(NSUInteger)len {
    return [_data countByEnumeratingWithState:state objects:buffer count:len];
}

- (NSUInteger) count {
    return [_data count];
}


@end