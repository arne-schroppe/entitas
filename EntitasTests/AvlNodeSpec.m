#import "Kiwi.h"
#import "AvlNode.h"

SPEC_BEGIN(AvlNodeSpec)

describe(@"AvlNode", ^{

    __block AvlNode *node;
    __block EqualityComparer comparater;

    beforeEach(^{
	
        NSDictionary *lookup = @{@"a" : @1, @"b" : @2, @"c": @3};
        
        comparater = ^int(id o1, id o2){
            return [lookup[o2] integerValue] - [lookup[o1] integerValue];
        };
        
        node = [AvlNode emptyWithComparer:comparater];

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
