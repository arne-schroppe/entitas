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

- (void)entityChanged:(NSNotification *)notification
{
    ESChangedEntity *entity = [[notification userInfo] objectForKey:[ESChangedEntity class]];
    [_changes addObject:entity];
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(entityChanged:) name:ESEntityAdded object:_collection];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(entityChanged:) name:ESEntityRemoved object:_collection];
}

- (void)stopRecording
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ESEntityAdded object:_collection];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ESEntityRemoved object:_collection];
}

@end