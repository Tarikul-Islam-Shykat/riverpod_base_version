# Provider Types

## `Provider`

Used for services or objects that do not hold UI state.

Examples from this project:
- `imageServiceProvider`
- `secureStorageServiceProvider`
- `appDbProvider`
- `networkServiceProvider`
- `appLoggerServiceProvider`

## `NotifierProvider`

Used when a class owns mutable state and logic.

Example:

```dart
final counterProvider = NotifierProvider<CounterNotifier, int>(
  CounterNotifier.new,
);
```

This is used for the counter because the value changes over time.

## `StreamProvider`

Used when data comes as a stream.

Example:

```dart
final appLogsProvider = StreamProvider<List<AppLogEntry>>((ref) async* {
  final service = ref.watch(appLoggerServiceProvider);
  await service.initialize();
  yield service.logs;
  yield* service.watchLogs();
});
```

## What I Should Remember

- `Provider` is good for reusable services
- `NotifierProvider` is good for mutable state and logic
- `StreamProvider` is good for streams
- providers can depend on other providers
- Riverpod makes dependency management cleaner
