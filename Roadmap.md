Roadmap
====
 
### 0.1.1
- add ReactiveSystem
- add method - (NSArray *)getEntitiesWithComponentsOfType:(Class)type
- add methods to ESCollection:
  - entitiesWithoutTypes:(NSSet*)
  - entitiesWithoutMatcher:(ESMatcher*)
- make Entitas+Extensions.h and add:
  - a singleton tag component class
  - a singleton entity accesor category on EntityRepository
  - introduce sharedRepository and repositoryByName:(NSString*)
  - Base ESComponentClass with examples of handy class and instance methods

### 0.1.0 Improve usability:
	
- ~~remove defineComponent macro~~
- ~~put () around the getComponent macro so that getComponent().data syntax works~~
- ~~rename Entities to EntityRepository after DDD concepts~~
- ~~restructure public/private api~~
  - ~~Reduce public methods and make them private~~
  - ~~Create Entitas.h file witch contains all public .h files~~
  - ~~Create internal folder witch will contain all +Internal Categories~~
  - ~~Move internal API to internal Categories~~
- ~~remove ESComponent class and have only the prototype~~
- ~~Fix ESMatcher~~
- ~~get rid of ESChangedEntity~~
