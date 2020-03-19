# Intro (part 1)

## Introduction to Combine
Brief description. Quote Apple docs.

1. Note about functional reactive programming
2. Publisher/Subscriber (maybe mention marble diagrams)
3. When to use Combine
    - Note about disadvantages/difficulties
        - Paradigm shift for Developers. May slow development or onboarding.
        - Difficult to Debug
        - Can be difficult to find help/examples for more specific use cases.
4. Link to sources:
    - https://developer.apple.com/documentation/combine
    - https://heckj.github.io/swiftui-notes/

## Dive into Concepts
1. Publisher
    - Convenience Publishers: https://developer.apple.com/documentation/combine#3341324
    - Examples of URLSession, NotificationCenter, Timer
2. Subscriber
    - Cancellable
3. Operators
4. Subjects

---

# (Part 2)
## Revisit concepts
1. Publisher
    -Connectable publisher: https://developer.apple.com/documentation/combine/controlling_publishing_with_connectable_publishers
2. Operators are the magic

## More concepts
1. Single result vs. continuous sequence
2. Lifecycle
3. Type erasure
4. Back pressure

## Developing with Combine (rename this)
1. Creating publishers
    - Probably shouldn’t need to implement the Publisher protocol directly.
    - Just, Empty, Fail
    - Future
    - Deferred
        - DeferredFuture
    - Record
    - @Published
    - @ObservedObject
2. Implementing Publisher
3. Threading
4. Errors
    - Catch
    - mapError
    - tryMap
    - assertNoFailure
    - retry
    - delay

# (Part 3)
(show OpenWeatherApp)
## Patterns & Recipes (rename)
1. Convert closure-based API to Combine
2. One-shot asynchronous call with Future
3. Merge results using operators
4. Normalizing errors
5. Observe state changes using Subject
6. Combining publishers with operators
