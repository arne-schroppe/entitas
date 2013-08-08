
#define anyTypes(...) ([[ESAnyComponentTypes alloc] initWithClasses: __VA_ARGS__ ])
#define allTypes(...) ([[ESAllComponentTypes alloc] initWithClasses: __VA_ARGS__ ])

#define anyMatchers(...) ([[ESAnyMatcher alloc] initWithMatchers: __VA_ARGS__ ])
#define allMatchers(...) ([[ESAllMatcher alloc] initWithMatchers: __VA_ARGS__ ])