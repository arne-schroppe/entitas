#import "AvlNode.h"

@class AvlNode;

@implementation AvlNode {
    AvlNode *_left;
    AvlNode *_right;
    int _count;
    int _depth;
}

- (AvlNode *) left
{
	return _left;
}

- (AvlNode *) right
{
	return _right;
}

- (int) count{
    return _count;
}
- (int) depth{
    return _depth;
}

- (int) balance
{
	return _left.depth - _right.depth;
}

- (id)initWithValue:(id)value andIndex:(u_long)index
{
	return [self initWithValue:value left:nil right:nil index:index];
}

- (id)initWithValue:(id)value
               left:(AvlNode *)lt
              right:(AvlNode *)gt
              index:(u_long)index
{
	if ( ( self = [super init] ) )
	{
        [self setValue:value left:lt right:gt index:index];
	}
    
	return self;
}

- (void)setValue:(id)value
            left:(AvlNode *)lt
           right:(AvlNode *)gt
           index:(u_long)index
{
	_value = value;
	_left = lt;
	_right = gt;
	_count = 1 + _left.count + _right.count;
	_depth = 1 + MAX( _left.depth, _right.depth );
    _index = index;
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
			AvlNode *newroot = [self newOrMutate:_value left:newlt right:_right index:_index];
            
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
			AvlNode *newroot = [self newOrMutate:_value left:_left right:newgt index:_index];
            
			return [newroot rotateToLT];
		}
        
		[NSException raise:@"RTDict too unbalanced" format:@"RTDict too unbalanced: %d", rightBalance];
	}
    
	//In this case we can show: |bal| > 2
	//if( Math.Abs(bal) > 2 ) {
	[NSException raise:@"Tree too out of balance" format:@"Tree too out of balance: %d", bal];
	
	return nil;
}

- (AvlNode *)newWithValue:(id)val andIndex:(u_long)newValueIndex {
    
	AvlNode *newlt = _left;
	AvlNode *newgt = _right;

	id newv = _value;
	u_long newIndex = _index;

	if ( newValueIndex < _index )
	{
		if(!_left){
            newlt = [[AvlNode alloc] initWithValue:val andIndex:newValueIndex];
        } else {
            newlt = [_left newWithValue:val andIndex:newValueIndex];
        }
	}
	else if ( newValueIndex > _index )
	{
		if(!_right){
            newgt = [[AvlNode alloc] initWithValue:val andIndex:newValueIndex];
        } else{
            newgt = [_right newWithValue:val andIndex:newValueIndex];
        }
	}
    
	else
	{
		newv = val;
        newIndex = newValueIndex;
	}
    
	AvlNode *newroot = [self newOrMutate:newv left:newlt right:newgt index:newIndex];
    
	return [newroot fixRootBalance];
}

- (AvlNode *)newWithoutValueOnIndex:(u_long)removedValueIndex
{
    BOOL found = NO;
    return [self removedValueOnIndex:removedValueIndex found:&found];
}

- (AvlNode *)removedValueOnIndex:(u_long)removedValueIndex
                           found:(BOOL *)found
{


	if ( removedValueIndex < _index )
	{
		AvlNode *newlt = [_left removedValueOnIndex:removedValueIndex found:found];
        
		if ( !*found )
		{
			//Not found, so nothing changed
			return self;
		}
        
		AvlNode *newroot = [self newOrMutate:_value left:newlt right:_right index:_index];
        
		return [newroot fixRootBalance];
	}
    
	if ( removedValueIndex > _index )
	{
		AvlNode *newgt = [_right removedValueOnIndex:removedValueIndex found:found];
        
		if ( !*found )
		{
			//Not found, so nothing changed
			return self;
		}
        
		AvlNode *newroot = [self newOrMutate:_value left:_left right:newgt index:_index];
        
		return [newroot fixRootBalance];
	}
    
	//found it
	*found = YES;
    
	return [self removeRoot];
}

- (AvlNode *) removeMax:(AvlNode **)max
{
//	if ( [self isEmpty] )
//	{
//		AvlNode *empty = [AvlNode emptyWithComparator:_comparatorDelegate];
//		*max = empty;
//        
//		return empty;
//	}
    
	if ( !_right )
	{
		//We are the max:
		*max = self;
        
		return _left;
	}
	else
	{
		//Go down:
		AvlNode *newgt = [_right removeMax:max];
		AvlNode *newroot = [self newOrMutate:_value left:_left right:newgt index:_index];
        
		return [newroot fixRootBalance];
	}
}

- (AvlNode *) removeMin:(AvlNode **)min
{
//	if ( [self isEmpty] )
//	{
//		AvlNode *empty = [AvlNode emptyWithComparator:_comparatorDelegate];
//		*min = empty;
//        
//		return empty;
//	}
    
	if ( !_left )
	{
		//We are the minimum:
		*min = self;
        
		return _right;
	}
	else
	{
		//Go down:
		AvlNode *newlt = [_left removeMin:min];
		AvlNode *newroot = [self newOrMutate:_value left:newlt right:_right index:_index];
        
		return [newroot fixRootBalance];
	}
}

- (AvlNode *) removeRoot
{
	
    
	if ( !_left )
	{
		return _right;
	}
    
	if ( !_right )
	{
		return _left;
	}
    
	//Neither are empty:
	if ( _left->_count < _right->_count)
	{
		//LTDict has fewer, so promote from GTDict to minimize depth
		AvlNode *min;
		AvlNode *newgt = [_right removeMin:&min];
		AvlNode *newroot = [self newOrMutate:min.value left:_left right:newgt index:min.index];
        
		return [newroot fixRootBalance];
	}
	else
	{
		AvlNode *max;
		AvlNode *newlt = [_left removeMax:&max];
		AvlNode *newroot = [self newOrMutate:max.value left:newlt right:_right index:max.index];
        
		return [newroot fixRootBalance];
	}
}

- (AvlNode *) rotateToGT
{
//	if ( [_left isEmpty] || [self isEmpty] )
//	{
//		return self;
//	}
    
    AvlNode *lL = _left.left;
	AvlNode *lR = _left.right;
	AvlNode *newRight = [self newOrMutate:_value left:lR right:_right index:_index];
    
	return [_left newOrMutate:_left.value left:lL right:newRight index:_left.index];
}

- (AvlNode *) rotateToLT
{
//	if ( [_right isEmpty] || [self isEmpty] )
//	{
//		return self;
//	}
    
    AvlNode *rL = _right.left;
	AvlNode* rR = _right.right;
	AvlNode *newLeft = [self newOrMutate:_value left:_left right:rL index:_index];
    
	return [_right newOrMutate:_right.value left:newLeft right:rR index:_right.index];
}

- (AvlNode *)newOrMutate:(id)newValue left:(AvlNode *)newLeft right:(AvlNode *)newRight index:(u_long)index {
	
    return [[AvlNode alloc] initWithValue:newValue left:newLeft right:newRight index:index];
}

- (NSArray *)allObjects
{
	NSMutableArray *result = [NSMutableArray new];
	[self fillArray:result];
	return result;
}

-(void)fillArray:(NSMutableArray *)array{
	if (_left){
		[_left fillArray:array];
	}
	if(_value){
		[array addObject:_value];
	}
	if (_right){
		[_right fillArray:array];
	}
}

@end