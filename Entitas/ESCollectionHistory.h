#import <Foundation/Foundation.h>
#import "ESCollection.h"

@class ESCollection;

@interface ESCollectionHistory : NSObject <ESCollectionObserver>
- (id)initWithCollection:(ESCollection *)collection;
- (ESCollection *)collection;
- (NSArray *)changes;
- (void)clearChanges;
- (void)startRecording;
- (void)stopRecording;
@end