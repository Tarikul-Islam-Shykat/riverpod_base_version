# Riverpod Interview Guide

This note is only about Riverpod ideas used in this project.

Use it when you want to answer:

- what does this Riverpod thing do?
- when should I use it?
- when should I not use it?
- why is this provider written this way?

## 1. `Provider`

Use `Provider` for simple objects that do not hold mutable UI state.

Examples in this project:

- `networkServiceProvider`
- `appDbProvider`
- `userRemoteDataSourceProvider`
- `userRepositoryProvider`
- `getUsersUseCaseProvider`
- `localUserUseCaseProvider`

### What it does

It creates and shares one object.

### When to use

Use it for:

- services
- repositories
- use cases
- helpers

### When not to use

Do not use it for:

- loading UI state
- async data you want the UI to watch directly

## 2. `FutureProvider`

Use `FutureProvider` for one async request that returns a single result.

Examples:

- `usersProvider`
- `savedUserProvider`

### What it does

It gives the UI:

- loading
- error
- data

### When to use

Use it when the UI needs async data from one future call.

### When not to use

Do not use it when:

- you need continuous updates
- you need a stream
- you want local mutable UI state

## 3. `FutureProvider.family`

Use `family` when the provider needs an argument.

Example:

```dart
commentsProvider(postId)
```

### What it does

It creates a separate provider instance for each input value.

### When to use

Use it when data depends on an id, key, or filter.

Examples:

- `postId`
- `userId`
- search query

### When not to use

Do not use it when the provider does not need input.

## 4. `autoDispose`

Use `autoDispose` when the provider should be cleaned up when the screen or widget stops using it.

Examples:

- `usersProvider`
- `savedUserProvider`
- `commentsProvider`

### What it does

It frees provider state automatically when it is no longer needed.

### When to use

Use it for:

- pages
- sheets
- temporary async data

### When not to use

Do not use it if you want the state to stay alive globally.

## 5. `ref.read`

Use `ref.read` when you want an object once and do not want rebuilds.

Examples:

```dart
final repository = ref.read(userRepositoryProvider);
```

### What it does

It reads the current provider value.

### When to use

Use it:

- inside provider factories
- inside button handlers
- when calling a method on a service

### When not to use

Do not use it in the UI when you want the screen to react to changes.

## 6. `ref.watch`

Use `ref.watch` when the UI should rebuild when the provider changes.

Example:

```dart
final usersAsync = ref.watch(usersProvider);
```

### What it does

It listens to the provider.

### When to use

Use it in:

- `build()` methods
- widgets that need live updates

### When not to use

Do not use it for simple one-time access inside button callbacks.

## 7. `ref.refresh`

Use `ref.refresh` when you want to run a provider again right now.

Example:

```dart
await ref.refresh(usersProvider.future);
```

### What it does

It forces a new fetch.

### When to use

Use it for:

- pull to refresh
- reload buttons

### When not to use

Do not use it if you only want to mark something stale for later.

## 8. `ref.invalidate`

Use `ref.invalidate` when you want Riverpod to forget the current value and rebuild later.

Example:

```dart
ref.invalidate(savedUserProvider);
```

### What it does

It marks the provider as stale.

### When to use

Use it when:

- local data changed
- you want the next watch to reload

### When not to use

Do not use it when you need the new value immediately.

## 9. `ref.onDispose`

Use `ref.onDispose` inside a provider when the created object needs cleanup.

Example:

```dart
ref.onDispose(service.dispose);
```

### What it does

It registers cleanup code.

### When to use

Use it for:

- streams
- controllers
- database objects
- services with `dispose()`

## 10. `ConsumerWidget`

Use `ConsumerWidget` when a widget needs Riverpod access through `WidgetRef`.

Example:

```dart
class UsersPage extends ConsumerWidget
```

### What it does

It lets the widget call:

- `ref.watch`
- `ref.read`
- `ref.refresh`
- `ref.invalidate`

### When to use

Use it when a screen needs providers.

### When not to use

Do not use it if the widget never touches Riverpod.

## 11. `WidgetRef`

`WidgetRef` is the Riverpod reference available inside a `ConsumerWidget`.

It is how the UI talks to providers.

Example:

```dart
Widget build(BuildContext context, WidgetRef ref)
```

## 12. Provider Dependency Chain

In this project, provider dependency works like this:

```text
usersProvider
-> getUsersUseCaseProvider
-> userRepositoryProvider
-> userRemoteDataSourceProvider
-> networkServiceProvider
```

### Why this matters

Each provider depends on the one below it because it needs that object to do its job.

Example:

```dart
final userRepositoryProvider = Provider<UserRepository>((ref) {
  final remoteDataSource = ref.read(userRemoteDataSourceProvider);
  final localDataSource = ref.read(userLocalDataSourceProvider);
  return UserRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
  );
});
```

This means:

- repository provider depends on data source providers
- use case provider depends on repository provider
- UI provider depends on use case provider

## 13. Interview Short Answers

### Why use `Provider` for services?

Because services do not usually hold UI state. They are shared objects.

### Why use `FutureProvider` for GET APIs?

Because GET APIs usually return one async result with loading/error/data states.

### Why use `family`?

Because the provider needs an input like `postId`.

### Why use `autoDispose`?

Because the screen or sheet does not need to keep state forever.

### Why use `ref.read` inside providers?

Because provider setup usually needs one-time access to dependencies.

### Why use `ref.watch` in UI?

Because the UI should rebuild when data changes.

### Why not call API directly in the widget?

Because Riverpod and the data layer should handle the flow, not the widget.

## 14. Quick Rule

- `Provider` = create shared object
- `FutureProvider` = async single result
- `family` = provider needs input
- `autoDispose` = clean up when unused
- `ref.read` = get once
- `ref.watch` = listen and rebuild
- `ref.refresh` = fetch again now
- `ref.invalidate` = mark stale

