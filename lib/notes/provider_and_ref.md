# Provider and `ref`

## What This Means

This line:

```dart
final imageServiceProvider = Provider((ref) => ImageService());
```

means:
- create an `ImageService`
- make it available through Riverpod
- allow other widgets and providers to access it

So the provider is not the service itself.
It is a way to expose the service to the app.

## What the `ref` Parameter Does

Inside `Provider((ref) { ... })`, Riverpod gives me a `ref` so the provider can:
- depend on other providers
- register cleanup logic with `ref.onDispose(...)`

This is different from `ref.read(...)` in widgets.

## Why `ref.onDispose(...)` Exists

This tells Riverpod:
- when this provider is removed from memory
- call the cleanup function

That is useful for:
- streams
- controllers
- subscriptions
- timers
- sockets

In my logger service, the `StreamController` should be closed when the provider is disposed.

## Simple Rule

- `Provider(...)` is for creating and exposing an object
- `ref` inside the provider is for setup and cleanup
- `ref.read(...)` outside the provider is for using the object
