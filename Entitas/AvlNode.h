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

+ (AvlNode *)emptyWithComparator:(id <AvlNodeComparatorDelegate>)comparatorDelegate;

- (BOOL) isEmpty;

- (AvlNode *) left;

- (AvlNode *) right;

- (int) balance;

- (AvlNode *) newWithValue:(id)val;

- (AvlNode *) newWithoutValue:(id)index;

- (NSEnumerator *)enumerator;

@property (nonatomic, strong) id value;

@property (assign) id <AvlNodeComparatorDelegate> comparatorDelegate;

@end