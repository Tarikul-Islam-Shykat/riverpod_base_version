# `StreamProvider`

## What It Is

`StreamProvider` is part of Riverpod.

It is used when data changes over time and comes from a `Stream`.

Common examples:
- live updates
- websocket messages
- auth state changes
- database listeners
- my log list

## Why I Use It in the Logger

My logs are not a single fixed value.
They:
- start with saved data from storage
- change when new logs are added
- change when logs are cleared

So `StreamProvider` is a good fit.

## My Example

```dart
final appLogsProvider = StreamProvider<List<AppLogEntry>>((ref) async* {
  final service = ref.watch(appLoggerServiceProvider);
  await service.initialize();
  yield service.logs;
  yield* service.watchLogs();
});
```

## Why `async*` Is Used

`async*` means:
- the function is asynchronous
- and it returns multiple values over time

### `async`

Used because I need to wait for:

```dart
await service.initialize();
```

### `*`

The `*` means the function yields a stream of values, not just one value.

### `yield`

Used to send one value into the stream:

```dart
yield service.logs;
```

### `yield*`

Used to forward another stream into this one:

```dart
yield* service.watchLogs();
```

## In Simple Words

`StreamProvider` means:

> This value changes over time, so let the UI listen to it.
