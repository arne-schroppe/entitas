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
            [[node1.allObjects should] equal:@[@"a"]];
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
            [[node2.allObjects should] equal:@[@"a", @"b"]];
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
            [[node3.allObjects should] equal:@[@"a", @"b", @"c"]];
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
            [[node4.allObjects should] equal:@[@"a", @"b", @"c", @"d"]];
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
            [[node5.allObjects should] equal:@[@"a", @"b", @"c", @"d", @"e"]];
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
            [[node6.allObjects should] equal:@[@"a", @"b", @"c", @"d", @"e", @"f"]];
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
            [[node7.allObjects should] equal:@[@"a", @"c", @"d", @"e", @"f"]];
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
            [[node8.allObjects should] equal:@[@"a", @"b", @"c", @"e", @"f"]];
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
            [[node9.allObjects should] equal:@[@"a", @"b", @"e", @"f"]];
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
            [[node10.allObjects should] equal:@[@"b", @"e", @"f"]];
		});
        
        __block AvlNode *node11;
        
		it(@"should invoke compare when removing value d and balance", ^
           {
               // when
               node11 = [node10 newWithoutValueOnIndex:6];
               
               // then
               [[node11.value should] equal:@"e"];
               [[node11.left.value should] equal:@"b"];
               [node11.right.value shouldBeNil];
               [[node11.allObjects should] equal:@[@"b", @"e"]];
           });
        
        it(@"should make a left rotation and add another elelemnt to it", ^
           {
               // when
               AvlNode *rootNode = [[AvlNode alloc] initWithValue:@"a" andIndex:1];
               rootNode = [rootNode newWithValue:@"c" andIndex:3];
               rootNode = [rootNode newWithValue:@"b" andIndex:2];
               rootNode = [rootNode newWithValue:@" " andIndex:0];
               
               // then
               [[rootNode.value should] equal:@"b"];
               [[rootNode.left.value should] equal:@"a"];
               [[rootNode.right.value should] equal:@"c"];
               [[rootNode.allObjects should] equal:@[@" ", @"a", @"b", @"c"]];
           });
        
        it(@"should make a right rotation", ^
           {
               // when
               AvlNode *rootNode = [[AvlNode alloc] initWithValue:@"c" andIndex:3];
               rootNode = [rootNode newWithValue:@"b" andIndex:2];
               rootNode = [rootNode newWithValue:@"a" andIndex:1];
               
               // then
               [[rootNode.value should] equal:@"b"];
               [[rootNode.left.value should] equal:@"a"];
               [[rootNode.right.value should] equal:@"c"];
               [[rootNode.allObjects should] equal:@[@"a", @"b", @"c"]];
           });
        
        it(@"should make a right rotation 2", ^
           {
               // when
               AvlNode *rootNode = [[AvlNode alloc] initWithValue:@"d" andIndex:4];
               rootNode = [rootNode newWithValue:@"a" andIndex:1];
               rootNode = [rootNode newWithValue:@"b" andIndex:2];
               rootNode = [rootNode newWithValue:@"c" andIndex:3];
               
               // then
               [[rootNode.value should] equal:@"b"];
               [[rootNode.left.value should] equal:@"a"];
               [[rootNode.right.value should] equal:@"d"];
               [[rootNode.right.left.value should] equal:@"c"];
               [[rootNode.allObjects should] equal:@[@"a", @"b", @"c", @"d"]];
           });
        
        it(@"should update the value for same index", ^
           {
               // when
               AvlNode *rootNode = [[AvlNode alloc] initWithValue:@"c" andIndex:3];
               rootNode = [rootNode newWithValue:@"z" andIndex:3];
               
               // then
               [[rootNode.value should] equal:@"z"];
               [[rootNode.allObjects should] equal:@[@"z"]];
           });
        
        it(@"should not remove element on non existing index (index is smaller than root index)", ^
           {
               // when
               AvlNode *rootNode = [[AvlNode alloc] initWithValue:@"c" andIndex:3];
               rootNode = [rootNode newWithoutValueOnIndex:1];
               
               // then
               [[rootNode.value should] equal:@"c"];
               [[rootNode.allObjects should] equal:@[@"c"]];
           });
        
        it(@"should not remove element on non existing index (index is bigger than root index)", ^
           {
               // when
               AvlNode *rootNode = [[AvlNode alloc] initWithValue:@"c" andIndex:3];
               rootNode = [rootNode newWithoutValueOnIndex:5];
               
               // then
               [[rootNode.value should] equal:@"c"];
               [[rootNode.allObjects should] equal:@[@"c"]];
           });
        
        it(@"should remove root with only left child", ^
           {
               // when
               AvlNode *rootNode = [[AvlNode alloc] initWithValue:@"c" andIndex:3];
               rootNode = [rootNode newWithValue:@"b" andIndex:2];
               rootNode = [rootNode newWithoutValueOnIndex:3];
               
               // then
               [[rootNode.value should] equal:@"b"];
               [[rootNode.allObjects should] equal:@[@"b"]];
           });
        
        it(@"should remove where left count is smaller than the right count", ^
           {
               // when
               AvlNode *rootNode = [[AvlNode alloc] initWithValue:@"c" andIndex:3];
               rootNode = [rootNode newWithValue:@"b" andIndex:2];
               rootNode = [rootNode newWithValue:@"e" andIndex:5];
               rootNode = [rootNode newWithValue:@"d" andIndex:4];
               rootNode = [rootNode newWithoutValueOnIndex:3];
               
               // then
               [[rootNode.value should] equal:@"d"];
               [[rootNode.left.value should] equal:@"b"];
               [[rootNode.right.value should] equal:@"e"];
               [[rootNode.allObjects should] equal:@[@"b", @"d", @"e"]];
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
    
    it(@"should create 2000 elements and than remove 100 elements randomely", ^{
        AvlNode *rootNode = [[AvlNode alloc] initWithValue:@"0" andIndex:0];
        NSMutableArray *indexiesToRemove = [NSMutableArray new];
        [indexiesToRemove addObject:@"0"];
        for(int i = 1; i < 2000; i++){
            rootNode = [rootNode newWithValue:[NSString stringWithFormat:@"%i", i] andIndex:i];
            [indexiesToRemove addObject:[NSString stringWithFormat:@"%i", i]];
        }
        
        for(int i = 0; i < 100; i++){
            int randomIndex = arc4random() % indexiesToRemove.count;
            int index = [indexiesToRemove[randomIndex] intValue];
            rootNode = [rootNode newWithoutValueOnIndex:index];
            [indexiesToRemove removeObjectAtIndex:randomIndex];
        }
        
        [[rootNode.allObjects should] equal:indexiesToRemove];
        NSLog(@"%i ------------ %i", rootNode.allObjects.count, indexiesToRemove.count);
       
    });

});

SPEC_END
