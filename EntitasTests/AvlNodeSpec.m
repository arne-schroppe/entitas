#import "Kiwi.h"
#import "AvlNode.h"


@interface ComparatorDelegateFake : NSObject <AvlNodeComparatorDelegate>
@property NSDictionary *lookup;
@end

@implementation ComparatorDelegateFake

- (int)compareValue:(id)value01 withValue:(id)value02
{
	if(_lookup[value01] > _lookup[value02]){
		return -1;
	} else if (_lookup[value01] < _lookup[value02]) {
		return 1;
	}
	return 0;
}

@end


SPEC_BEGIN(AvlNodeSpec)

describe(@"AvlNode", ^{

    __block AvlNode *node;
    __block ComparatorDelegateFake *compareDelegate;

    beforeEach(^{

		compareDelegate = [ComparatorDelegateFake new];
		compareDelegate.lookup = @{@"a" : @1, @"b" : @2, @"c": @3};
        
        node = [AvlNode emptyWithComparator:compareDelegate];

    });

    it(@"should return a sorted array of entered elements", ^{
        // given 

        node = [[[node newWithValue:@"a"] newWithValue:@"b"] newWithValue:@"c"];
        
        // when

        NSArray *result = [node enumerator].allObjects;

        // then
        [[result should] equal:@[@"a", @"b", @"c"]];

    });

    it(@"should remove added elements", ^{
        // given

        AvlNode *avlNode1 = [node newWithValue:@"a"];
        AvlNode *avlNode2 = [avlNode1 newWithoutValue:@"a"];

        [[avlNode1.enumerator.allObjects should] equal:@[@"a"]];
        [[avlNode2.enumerator.allObjects should] equal:@[]];

        AvlNode *avlNode3 = [avlNode1 newWithValue:@"b"];
        [[avlNode3.enumerator.allObjects should] equal:@[@"a", @"b"]];

    });
    
    it(@"should not remove not contained value", ^{

        // given

        AvlNode *avlNode1 = [node newWithValue:@"a"];
        AvlNode *avlNode2 = [avlNode1 newWithValue:@"b"];
        AvlNode *avlNode3 = [avlNode2 newWithValue:@"c"];
        AvlNode *avlNode4 = [avlNode3 newWithoutValue:@"d"];

        // then
        [[[avlNode1 enumerator].allObjects should] equal:@[@"a"]];
        [[[avlNode2 enumerator].allObjects should] equal:@[@"a", @"b"]];
        [[[avlNode3 enumerator].allObjects should] equal:@[@"a", @"b", @"c"]];
        [[[avlNode4 enumerator].allObjects should] equal:@[@"a", @"b", @"c"]];

    });

});

SPEC_END
