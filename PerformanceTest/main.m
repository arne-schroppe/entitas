#import "ESEntities+Internal.h"
#import "SomeComponent.h"
#import "SomeOtherComponent.h"
#import "MGBenchmark.h"
#import "MGBenchmarkSession.h"

#import <Foundation/Foundation.h>

void test1(){
    
    
    // given
    
    ESEntities *entities = [ESEntities new];
    
    MGBenchStart(@"Test");
    
    for (int j = 0; j < 1000000; j++) {
        ESEntity *entity = [entities createEntity];
        if (j%25 == 0){
            [entity addComponent:[SomeComponent new]];
        }
        if (j%25 == 1){
            [entity addComponent:[SomeOtherComponent new]];
        }
    }
    
    MGBenchStep(@"Test", @"Mio entities are created");
    
    ESCollection *collection = [entities collectionForTypes:[NSSet setWithObject:[SomeComponent class]]];
    
    MGBenchStep(@"Test", @"Collection is created");
    
    NSArray *collectedEntities;
    for (int i = 0; i < 100; i++) {
        collectedEntities = collection.entities;
    }
    
    MGBenchStep(@"Test", @"Getting all entities from collection 100 times");
    
    for (ESEntity *entity in collectedEntities) {
        [entity exchangeComponent:[SomeComponent new]];
    }
    
    MGBenchStep(@"Test", @"Exchanged component in all entities of the collection");
    
    for (ESEntity *entity in entities.allEntities) {
        [entities destroyEntity:entity];
    }
    
    MGBenchStep(@"Test", @"Destroy all entities");
    
    NSLog(@"Entities Left: %lu", (unsigned long)entities.allEntities.count);
    
    MGBenchEnd(@"Test");

}


int main(int argc, const char * argv[])
{

    @autoreleasepool {
        
        test1();
        
    }
    return 0;
}