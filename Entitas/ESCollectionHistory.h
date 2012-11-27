#import <Foundation/Foundation.h>

@class ESCollection;


@interface ESCollectionHistory : NSObject
- (id)initWithCollection:(ESCollection *)collection;

- (ESCollection *)collection;

- (NSArray *)changes;

- (void)clearChanges;

- (void)startRecording;

- (void)stopRecording;
@end