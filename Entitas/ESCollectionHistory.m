#import "ESCollectionHistory.h"
#import "ESCollection.h"
#import "ESChangedEntity.h"

@implementation ESCollectionHistory
{
    ESCollection *_collection;
    NSMutableArray *_changes;
}

- (id)initWithCollection:(ESCollection *)collection
{
    self = [super init];
    if (self)
    {
        _changes = [NSMutableArray array];
        _collection = collection;
    }
    return self;
}

- (ESCollection *)collection
{
    return _collection;
}

- (NSArray *)changes
{
    return _changes;
}

- (void)clearChanges
{
    [_changes removeAllObjects];
}

- (void)startRecording
{
    [_collection addObserver:self forEvent:ESEntityAdded];
    [_collection addObserver:self forEvent:ESEntityRemoved];
}

- (void)stopRecording
{
    [_collection removeObserver:self forEvent:ESEntityAdded];
    [_collection removeObserver:self forEvent:ESEntityRemoved];
}

- (void)entity:(ESChangedEntity *)changedEntity changedInCollection:(ESCollection *)collection {
    [_changes addObject:changedEntity];
}


@end