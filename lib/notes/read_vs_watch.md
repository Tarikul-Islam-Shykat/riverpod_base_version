# `read` vs `watch`

## `ref.read`

Use this when:
- I only need the object once
- I want to call a method
- I do not need the UI to rebuild from this provider

Example:

```dart
final imageService = ref.read(imageServiceProvider);
```

## `ref.watch`

Use this when:
- I want the widget to rebuild if the provider value changes
- I am reading state that affects the UI
- I want to listen to reactive data

Example:

```dart
final logsAsync = ref.watch(appLogsProvider);
```

## Simple Rule

- `read` is for using a service
- `watch` is for reacting to changing data

## In My Project

- `ref.read(appLoggerServiceProvider)` is used when I want to call logger methods
- `ref.watch(appLogsProvider)` is used when the log viewer should update automatically
