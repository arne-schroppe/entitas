//
//  AvlNode.h
//  AVL tree / Node
//
//  Inspired by Chris Cavanagh
//  https://gist.github.com/BobStrogg/8449933

typedef int (^EqualityComparer)( id v1, id v2 );

@interface AvlNode : NSObject

+ (AvlNode *) emptyWithComparer:(EqualityComparer)comparer;

- (BOOL) isEmpty;

- (AvlNode *) left;

- (AvlNode *) right;

- (u_long) count;

- (int) balance;

- (AvlNode *) newWithValue:(id)val;

- (AvlNode *) newWithoutValue:(id)index;

- (NSEnumerator *)enumerator;

@property (nonatomic, strong) id value;
@property (assign) EqualityComparer comparer;

@end