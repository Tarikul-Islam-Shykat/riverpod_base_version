# App Log Service

This logging service is a simple in-project alternative to using the `logger` package directly.
It does three things:

- prints formatted logs to the debug console
- saves recent logs with `shared_preferences`
- exposes a screen so you can inspect and clear them inside the app

## Available methods

```dart
final logger = ref.read(appLoggerServiceProvider);

await logger.t('Trace log');
await logger.d('Debug log');
await logger.i('Info log');
await logger.w('Warning log');
await logger.e('Error log', error: 'Test Error');
await logger.f('Fatal log', error: error, stackTrace: stackTrace);
```

## JSON and response formatting

```dart
await logger.i(
  'Fetched profile response',
  tag: 'AuthApi',
  data: {
    'success': true,
    'user': {'id': 1, 'name': 'Shykat'},
  },
);
```

Maps, lists, and JSON strings are pretty-printed before they are stored and shown in the log viewer.

## Open the log screen

```dart
Navigator.of(context).push(
  MaterialPageRoute(builder: (_) => const LogViewerScreen()),
);
```

## Notes

- The service keeps the newest logs first.
- Logs are capped to the most recent 200 entries.
- `shared_preferences` is used only for simple persistence, not for sensitive data.
- Each log also captures the caller's source location automatically, so the viewer can show the file path and line number.
