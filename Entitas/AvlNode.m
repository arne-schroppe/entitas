#import "AvlNode.h"

@class AvlNode;

@interface NullNode : AvlNode
@end

@implementation AvlNode {
    AvlNode *_left;
    AvlNode *_right;
    u_long _count;
    int _depth;
}

+ (AvlNode *)emptyWithComparator:(id <AvlNodeComparatorDelegate>)comparatorDelegate
{
    AvlNode *empty = [NullNode new];

	empty.comparatorDelegate = comparatorDelegate;
	return empty;
}

- (BOOL) isEmpty
{
	return NO;
}

- (AvlNode *) left
{
	return _left;
}

- (AvlNode *) right
{
	return _right;
}

- (int) balance
{
	if ( [self isEmpty] ) return 0;
	return _left->_depth - _right->_depth;
}

- (id)initWithValue:(id)value andComparator:(id <AvlNodeComparatorDelegate>)comparatorDelegate
{
	AvlNode *empty = [AvlNode emptyWithComparator:comparatorDelegate];
    
	return [self initWithValue:value left:empty right:empty comparator:comparatorDelegate];
}

- (id)initWithValue:(id)value
			   left:(AvlNode *)lt
			  right:(AvlNode *)gt
		 comparator:(id <AvlNodeComparatorDelegate>)comparatorDelegate
{
	if ( ( self = [super init] ) )
	{
		[self setValue:value left:lt right:gt comparator:comparatorDelegate];
	}
    
	return self;
}

- (void)setValue:(id)value
			left:(AvlNode *)lt
		   right:(AvlNode *)gt
	  comparator:(id <AvlNodeComparatorDelegate>)comparatorDelegate
{
	_value = value;
	_left = lt;
	_right = gt;
	_count = 1 + _left->_count + _right->_count;
	_depth = 1 + MAX( _left->_depth, _right->_depth );
    _comparatorDelegate = comparatorDelegate;
}

- (AvlNode *) fixRootBalance
{
	int bal = [self balance];
    
	if ( abs( bal ) < 2 ) return self;
    
	if ( bal == 2 )
	{
		int leftBalance = [_left balance];
        
		if ( leftBalance == 1 || leftBalance == 0 )
		{
			//Easy case:
			return [self rotateToGT];
		}
        
		if ( leftBalance == -1 )
		{
			//Rotate LTDict:
			AvlNode *newlt = [_left rotateToLT];
			AvlNode *newroot = [self newOrMutate:_value left:newlt right:_right];
            
			return [newroot rotateToGT];
		}
        
		[NSException raise:@"LTDict too unbalanced" format:@"LTDict too unbalanced: %d", leftBalance];
	}
    
	if ( bal == -2 )
	{
		int rightBalance = [_right balance];
        
		if ( rightBalance == -1 || rightBalance == 0 )
		{
			//Easy case:
			return [self rotateToLT];
		}
        
		if ( rightBalance == 1 )
		{
			//Rotate GTDict:
			AvlNode *newgt = [_right rotateToGT];
			AvlNode *newroot = [self newOrMutate:_value left:_left right:newgt];
            
			return [newroot rotateToLT];
		}
        
		[NSException raise:@"RTDict too unbalanced" format:@"RTDict too unbalanced: %d", rightBalance];
	}
    
	//In this case we can show: |bal| > 2
	//if( Math.Abs(bal) > 2 ) {
	[NSException raise:@"Tree too out of balance" format:@"Tree too out of balance: %d", bal];
	
	return nil;
}

- (AvlNode *)newWithValue:(id)val {
	if ( [self isEmpty] ) return [[AvlNode alloc] initWithValue:val andComparator:_comparatorDelegate];
    
	AvlNode *newlt = _left;
	AvlNode *newgt = _right;

	int comp = [_comparatorDelegate compareValue:_value withValue:val];
	id newv = _value;
    
	if ( comp < 0 )
	{
		newlt = [_left newWithValue:val];
	}
	else if ( comp > 0 )
	{
		newgt = [_right newWithValue:val];
	}
    
	else
	{
		newv = val;
	}
    
	AvlNode *newroot = [self newOrMutate:newv left:newlt right:newgt];
    
	return [newroot fixRootBalance];
}

- (AvlNode *) newWithoutValue:(id)value
{
    BOOL found = NO;
    return [self removeFromNew:value found:&found];
}

- (AvlNode *) removeFromNew:(id)value
					  found:(BOOL *)found
{
	if ( [self isEmpty] )
	{
		*found = NO;
		return [AvlNode emptyWithComparator:_comparatorDelegate];
	}

    int comp = [_comparatorDelegate compareValue:_value withValue:value];
    
	if ( comp < 0 )
	{
		AvlNode *newlt = [_left removeFromNew:value found:found];
        
		if ( !*found )
		{
			//Not found, so nothing changed
			return self;
		}
        
		AvlNode *newroot = [self newOrMutate:_value left:newlt right:_right];
        
		return [newroot fixRootBalance];
	}
    
	if ( comp > 0 )
	{
		AvlNode *newgt = [_right removeFromNew:value found:found];
        
		if ( !*found )
		{
			//Not found, so nothing changed
			return self;
		}
        
		AvlNode *newroot = [self newOrMutate:_value left:_left right:newgt];
        
		return [newroot fixRootBalance];
	}
    
	//found it
	*found = YES;
    
	return [self removeRoot];
}

- (AvlNode *) removeMax:(AvlNode **)max
{
	if ( [self isEmpty] )
	{
		AvlNode *empty = [AvlNode emptyWithComparator:_comparatorDelegate];
		*max = empty;
        
		return empty;
	}
    
	if ( [_right isEmpty] )
	{
		//We are the max:
		*max = self;
        
		return _left;
	}
	else
	{
		//Go down:
		AvlNode *newgt = [_right removeMax:max];
		AvlNode *newroot = [self newOrMutate:_value left:_left right:newgt];
        
		return [newroot fixRootBalance];
	}
}

- (AvlNode *) removeMin:(AvlNode **)min
{
	if ( [self isEmpty] )
	{
		AvlNode *empty = [AvlNode emptyWithComparator:_comparatorDelegate];
		*min = empty;
        
		return empty;
	}
    
	if ( [_left isEmpty] )
	{
		//We are the minimum:
		*min = self;
        
		return _right;
	}
	else
	{
		//Go down:
		AvlNode *newlt = [_left removeMin:min];
		AvlNode *newroot = [self newOrMutate:_value left:newlt right:_right];
        
		return [newroot fixRootBalance];
	}
}

- (AvlNode *) removeRoot
{
	if ( [self isEmpty] )
	{
		return self;
	}
    
	if ( [_left isEmpty] )
	{
		return _right;
	}
    
	if ( [_right isEmpty] )
	{
		return _left;
	}
    
	//Neither are empty:
	if ( _left->_count < _right->_count)
	{
		//LTDict has fewer, so promote from GTDict to minimize depth
		AvlNode *min;
		AvlNode *newgt = [_right removeMin:&min];
		AvlNode *newroot = [self newOrMutate:min.value left:_left right:newgt];
        
		return [newroot fixRootBalance];
	}
	else
	{
		AvlNode *max;
		AvlNode *newlt = [_left removeMax:&max];
		AvlNode *newroot = [self newOrMutate:max.value left:newlt right:_right];
        
		return [newroot fixRootBalance];
	}
}

- (AvlNode *) rotateToGT
{
	if ( [_left isEmpty] || [self isEmpty] )
	{
		return self;
	}
    
    AvlNode *lL = _left.left;
	AvlNode *lR = _left.right;
	AvlNode *newRight = [self newOrMutate:_value left:lR right:_right];
    
	return [_left newOrMutate:_left.value left:lL right:newRight];
}

- (AvlNode *) rotateToLT
{
	if ( [_right isEmpty] || [self isEmpty] )
	{
		return self;
	}
    
    AvlNode *rL = _right.left;
	AvlNode* rR = _right.right;
	AvlNode *newLeft = [self newOrMutate:_value left:_left right:rL];
    
	return [_right newOrMutate:_right.value left:newLeft right:rR];
}

- (AvlNode *) newOrMutate:(id)newValue
					 left:(AvlNode *)newLeft
					right:(AvlNode *)newRight
{
	
    return [[AvlNode alloc] initWithValue:newValue left:newLeft right:newRight comparator:_comparatorDelegate];
}

- (NSArray *)allObjects
{
	NSMutableArray *result = [NSMutableArray new];
	[self fillArray:result];
	return result;
}

-(void)fillArray:(NSMutableArray *)array{
	if (!_left.isEmpty){
		[_left fillArray:array];
	}
	if(_value){
		[array addObject:_value];
	}
	if (!_right.isEmpty){
		[_right fillArray:array];
	}
}

@end


@implementation NullNode

- (BOOL)isEmpty
{
	return YES;
}

@end