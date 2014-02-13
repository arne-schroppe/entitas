//
//  AvlNode.h
//  AVL tree / Node
//
//  Inspired by Chris Cavanagh
//  https://gist.github.com/BobStrogg/8449933


@protocol AvlNodeComparatorDelegate

- (int)compareValue:(id)value01 withValue:(id)value02;

@end


@interface AvlNode : NSObject

- (id)initWithValue:(id)value andComparator:(id <AvlNodeComparatorDelegate>)comparatorDelegate;

- (AvlNode *) left;

- (AvlNode *) right;

- (int) balance;
- (int) count;
- (int) depth;

- (AvlNode *) newWithValue:(id)val;

- (AvlNode *) newWithoutValue:(id)index;

@property (nonatomic, strong) id value;

- (NSArray *)allObjects;

@property (assign) id <AvlNodeComparatorDelegate> comparatorDelegate;

@end