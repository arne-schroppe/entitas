Roadmap
====

### 0.0.5

Performance optimizations

- Write Tests to measure performance
- Switch to C++ datastructures

### 0.1.0

Improve usability:
- Rename defineComponent Macro to defineLocalVariableComponent or delete it completely
- Entities should be renamed to EntityRepository after DDD concepts
- Rename Component to Attribute
- Make (Tag) Attributes Singletons
- Reduce public methods and make them private
- Create internal folder witch will contain all +Internal Categories
- get rid of ESCollection
- get rid of ESChangedEntity
- Move internal API to internal Categories
- introduce sharedRepository or repositoryByName:(NSString*)
- Create ES.h file witch contains all public .h files


0.1.0

Improve usability:
	
- remove defineComponent macro
- put () around the getComponent macro so that getComponent().data syntax works
- rename Entities to EntityRepository after DDD concepts
- (Do not rename Component)
- restructure public/private api
  - Reduce public methods and make them private
    - Pull in Dominic's changes on origin/feature/cleanup
  - Create Entitas.h file witch contains all public .h files
  - Create internal folder witch will contain all +Internal Categories
  - Move internal API to internal Categories
- remove ESComponent class and have only the prototype
- add method - (NSArray *)getEntitiesWithComponentsOfType:(Class)type
- ESMatcher just: method hasType: or something
- get rid of ESCollection
- get rid of ESChangedEntity
- make Entitas+Extensions.h and add:
  - a singleton tag component class
  - a singleton entity accesor category on EntityRepository
  - introduce sharedRepository and repositoryByName:(NSString*)

