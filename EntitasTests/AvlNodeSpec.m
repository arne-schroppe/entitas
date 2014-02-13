#import "Kiwi.h"
#import "AvlNode.h"





SPEC_BEGIN(AvlNodeSpec)

describe(@"AvlNode", ^{

    __block AvlNode *node;

    beforeEach(^{

        node = nil;

    });

	context(@"checking comparator usage", ^
	{

		__block AvlNode *node1;

		it(@"should not invoke comparator when adding value to  empty node", ^
		{

			node1 = [[AvlNode alloc] initWithValue:@"a" andIndex:1];
			[[node1.value should] equal:@"a"];
			[node1.left.value shouldBeNil];
			[node1.right.value shouldBeNil];

		});

		__block AvlNode *node2;

		it(@"should invoke compare when adding value b", ^
		{

			// when
			node2 = [node1 newWithValue:@"b" andIndex:2];

			// then
			[[node2.value should] equal:@"a"];
			[node2.left.value shouldBeNil];
			[[node2.right.value should] equal:@"b"];
		});


		__block AvlNode *node3;

		it(@"should invoke compare when adding value c and balance", ^
		{

			// when
			node3 = [node2 newWithValue:@"c" andIndex:3];

			// then
			[[node3.value should] equal:@"b"];
			[[node3.left.value should] equal:@"a"];
			[[node3.right.value should] equal:@"c"];
		});

		__block AvlNode *node4;

		it(@"should invoke compare when adding value d", ^
		{

			// when
			node4 = [node3 newWithValue:@"d" andIndex:4];

			// then
			[[node4.value should] equal:@"b"];
			[[node4.left.value should] equal:@"a"];
			[[node4.right.value should] equal:@"c"];
			[[node4.right.right.value should] equal:@"d"];
		});

		__block AvlNode *node5;

		it(@"should invoke compare when adding value e and balance", ^
		{
			// expectation

			// when
			node5 = [node4 newWithValue:@"e" andIndex:5];

			// then
			[[node5.value should] equal:@"b"];
			[[node5.left.value should] equal:@"a"];
			[[node5.right.value should] equal:@"d"];
			[[node5.right.left.value should] equal:@"c"];
			[[node5.right.right.value should] equal:@"e"];
		});

		__block AvlNode *node6;

		it(@"should invoke compare when adding value f and balance", ^
		{
			// when
			node6 = [node5 newWithValue:@"f" andIndex:6];

			// then
			[[node6.value should] equal:@"d"];
			[[node6.left.value should] equal:@"b"];
			[[node6.left.left.value should] equal:@"a"];
			[[node6.left.right.value should] equal:@"c"];
			[[node6.right.value should] equal:@"e"];
			[node6.right.left.value shouldBeNil];
			[[node6.right.right.value should] equal:@"f"];
		});

		__block AvlNode *node7;

		it(@"should invoke compare when removing value b and balance", ^
		{
			// when
			node7 = [node6 newWithoutValueOnIndex:2];

			// then
			[[node7.value should] equal:@"d"];
			[[node7.left.value should] equal:@"a"];
			[[node7.left.right.value should] equal:@"c"];
			[node7.left.left.value shouldBeNil];
			[[node7.right.value should] equal:@"e"];
			[node7.right.left.value shouldBeNil];
			[[node7.right.right.value should] equal:@"f"];
		});

		__block AvlNode *node8;

		it(@"should invoke compare when removing value d and balance", ^
		{
			// when
			node8 = [node6 newWithoutValueOnIndex:4];

			// then
			[[node8.value should] equal:@"c"];
			[[node8.left.value should] equal:@"b"];
			[[node8.left.left.value should] equal:@"a"];
			[[node8.right.value should] equal:@"e"];
			[[node8.right.right.value should] equal:@"f"];
		});

		__block AvlNode *node9;

		it(@"should invoke compare when removing value d and balance", ^
		{
			// when
			node9 = [node8 newWithoutValueOnIndex:3];

			// then
			[[node9.value should] equal:@"b"];
			[[node9.left.value should] equal:@"a"];
			[[node9.right.value should] equal:@"e"];
			[[node9.right.right.value should] equal:@"f"];
		});

		__block AvlNode *node10;

		it(@"should invoke compare when removing value d and balance", ^
		{
			// when
			node10 = [node9 newWithoutValueOnIndex:1];

			// then
			[[node10.value should] equal:@"e"];
			[[node10.left.value should] equal:@"b"];
			[[node10.right.value should] equal:@"f"];
		});
	});

	it(@"should create an expected tree", ^{

		// when

		AvlNode *node1 = [[AvlNode alloc] initWithValue:@"a" andIndex:1];
		[[node1.value should] equal:@"a"];
		[node1.left.value shouldBeNil];
		[node1.right.value shouldBeNil];


		AvlNode *node2 = [node1 newWithValue:@"b" andIndex:2];
		[[node2.value should] equal:@"a"];
		[node2.left.value shouldBeNil];
		[[node2.right.value should] equal:@"b"];
	});

    it(@"should return a sorted array of entered elements", ^{
        // given

        node = [[[[AvlNode alloc] initWithValue:@"a" andIndex:1] newWithValue:@"b" andIndex:2] newWithValue:@"c" andIndex:3];

        // when

        NSArray *result = node.allObjects;

        // then
        [[result should] equal:@[@"a", @"b", @"c"]];

    });

    it(@"should remove added elements", ^{
        // given

        AvlNode *avlNode1 = [[AvlNode alloc] initWithValue:@"a" andIndex:1];
        AvlNode *avlNode2 = [avlNode1 newWithoutValueOnIndex:1];

        [[avlNode1.allObjects should] equal:@[@"a"]];
        [avlNode2 shouldBeNil];

        AvlNode *avlNode3 = [avlNode1 newWithValue:@"b" andIndex:2];
        [[avlNode3.allObjects should] equal:@[@"a", @"b"]];

    });

    it(@"should not remove not contained value", ^{

        // given

        AvlNode *avlNode1 = [[AvlNode alloc] initWithValue:@"a" andIndex:1];
        AvlNode *avlNode2 = [avlNode1 newWithValue:@"b" andIndex:2];
        AvlNode *avlNode3 = [avlNode2 newWithValue:@"c" andIndex:3];
        AvlNode *avlNode4 = [avlNode3 newWithoutValueOnIndex:4];

        // then
        [[avlNode1.allObjects should] equal:@[@"a"]];
        [[avlNode2.allObjects should] equal:@[@"a", @"b"]];
        [[avlNode3.allObjects should] equal:@[@"a", @"b", @"c"]];
        [[avlNode4.allObjects should] equal:@[@"a", @"b", @"c"]];

    });

	it(@"should populate the array this values in the right order", ^
	{
		node = [[[[AvlNode alloc] initWithValue:@"a" andIndex:1] newWithValue:@"b" andIndex:2] newWithValue:@"c" andIndex:3];

		NSArray *allObjects = [node allObjects];

		[[allObjects should] equal:@[@"a", @"b", @"c"]];
	});

});

SPEC_END
