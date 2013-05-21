Entitas Ideas
====

Performance optimizations

- object-pool ESChangedEntity and use single instance for multiple collections (ESCollection#addEntity & ESCollection#removeEntity)
- swap to something more performant than NSNotificationCenter for collection updates (one-to-many)
- remove NSDictionary copy in ESEntity#components
- create a substitute-component method to not trigger removal/addition into collections and dispatch update event instead

Unsorted list of ideas for Entitas, we need to find a place to discuss them.

- Enity should have an ID
- Component should not be looked up by class instance but by class name
- Rename defineComponent Macro to defineLocalVariableComponent or delete it completely
- Reactive Mode should be configurable
- "execute" method on System should get delta time as parameter
- Entities should be renamed to EntityRepository after DDD concepts
- Add the singleton Macro so you can reuse (Tag) Components
- EntityRepository should provide getEntityById method
- Create ES.h file witch contains all public .h files
- Create internal folder witch will contain all +Internal Categories
- Move internal API to internal Categories
- Systems should have a NSBlockOperation property witch is executed before execute on each sub system.
- EntityRepository should reuse deleted Entities.
- Replace Notifications dispatched in ESCollection with Delegates
