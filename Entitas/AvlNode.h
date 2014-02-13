//
//  AvlNode.h
//  AVL tree / Node
//
//  Inspired by Chris Cavanagh
//  https://gist.github.com/BobStrogg/8449933


@interface AvlNode : NSObject

- (id)initWithValue:(id)value andIndex:(u_long)index;

- (AvlNode *) left;

- (AvlNode *) right;

- (int) balance;
- (int) count;
- (int) depth;

- (AvlNode *)newWithValue:(id)val andIndex:(u_long)newValueIndex;

- (AvlNode *)newWithoutValueOnIndex:(u_long)index;

@property (nonatomic, strong) id value;

- (NSArray *)allObjects;

//@property (assign) id <AvlNodeComparatorDelegate> comparatorDelegate;
@property (readonly) u_long index;

@end