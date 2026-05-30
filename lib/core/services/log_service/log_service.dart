import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'log_entry.dart';

final appLoggerServiceProvider = Provider<AppLoggerService>((ref) {
  final service = AppLoggerService();
  ref.onDispose(service.dispose);
  return service;
});

final appLogsProvider = StreamProvider<List<AppLogEntry>>((ref) async* {
  final service = ref.watch(appLoggerServiceProvider);
  await service.initialize();
  yield service.logs;
  yield* service.watchLogs();
});

class AppLoggerService {
  static const _storageKey = 'app_logger_entries';
  static const _maxLogEntries = 200;

  final StreamController<List<AppLogEntry>> _controller =
      StreamController<List<AppLogEntry>>.broadcast();

  List<AppLogEntry> _logs = const [];
  Future<void>? _initializing;

  List<AppLogEntry> get logs => List.unmodifiable(_logs);

  Future<void> initialize() {
    return _initializing ??= _loadLogs();
  }

  Stream<List<AppLogEntry>> watchLogs() => _controller.stream;

  void dispose() {
    _controller.close();
  }

  Future<void> clear() async {
    await initialize();
    _logs = const [];
    await _persist();
    _notify();
    debugPrint('🧹 [Logger] Cleared all logs');
  }

  Future<void> t(
    String message, {
    Object? data,
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    return log(
      AppLogLevel.trace,
      message,
      data: data,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
    );
  }

  Future<void> d(
    String message, {
    Object? data,
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    return log(
      AppLogLevel.debug,
      message,
      data: data,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
    );
  }

  Future<void> i(
    String message, {
    Object? data,
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    return log(
      AppLogLevel.info,
      message,
      data: data,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
    );
  }

  Future<void> w(
    String message, {
    Object? data,
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    return log(
      AppLogLevel.warning,
      message,
      data: data,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
    );
  }

  Future<void> e(
    String message, {
    Object? data,
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    return log(
      AppLogLevel.error,
      message,
      data: data,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
    );
  }

  Future<void> f(
    String message, {
    Object? data,
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    return log(
      AppLogLevel.fatal,
      message,
      data: data,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
    );
  }

  Future<void> log(
    AppLogLevel level,
    String message, {
    Object? data,
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) async {
    await initialize();

    final entry = AppLogEntry(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      level: level,
      message: message,
      timestamp: DateTime.now(),
      tag: tag,
      details: _formatData(data),
      error: error?.toString(),
      stackTrace: stackTrace?.toString(),
    );

    _logs = [entry, ..._logs].take(_maxLogEntries).toList(growable: false);
    await _persist();
    _notify();
    _printToConsole(entry);
  }

  Future<void> _loadLogs() async {
    final prefs = await SharedPreferences.getInstance();
    final rawLogs = prefs.getStringList(_storageKey) ?? const [];

    _logs = rawLogs
        .map(_tryParseLog)
        .whereType<AppLogEntry>()
        .toList(growable: false);

    _notify();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    final values = _logs.map((entry) => jsonEncode(entry.toJson())).toList();
    await prefs.setStringList(_storageKey, values);
  }

  void _notify() {
    if (!_controller.isClosed) {
      _controller.add(List.unmodifiable(_logs));
    }
  }

  void _printToConsole(AppLogEntry entry) {
    final buffer = StringBuffer()
      ..writeln(
        '${entry.level.emoji} [${entry.level.label.toUpperCase()}] '
        '${_formatTime(entry.timestamp)}'
        '${entry.tag == null ? '' : ' [${entry.tag}]'}',
      )
      ..writeln(entry.message);

    if (entry.details case final details?) {
      buffer
        ..writeln('Details:')
        ..writeln(details);
    }

    if (entry.error case final error?) {
      buffer.writeln('Error: $error');
    }

    if (entry.stackTrace case final stack?) {
      buffer
        ..writeln('StackTrace:')
        ..writeln(stack);
    }

    final formatted = buffer.toString().trimRight();
    debugPrint(formatted);
    developer.log(
      formatted,
      name: 'AppLogger',
      level: _developerLevel(entry.level),
      error: entry.error,
      stackTrace: entry.stackTrace == null
          ? null
          : StackTrace.fromString(entry.stackTrace!),
    );
  }

  String? _formatData(Object? data) {
    if (data == null) return null;

    if (data is Map || data is List) {
      return const JsonEncoder.withIndent('  ').convert(data);
    }

    if (data is String) {
      final trimmed = data.trim();
      if (trimmed.startsWith('{') || trimmed.startsWith('[')) {
        try {
          return const JsonEncoder.withIndent('  ')
              .convert(jsonDecode(trimmed));
        } catch (_) {
          return data;
        }
      }
      return data;
    }

    try {
      return const JsonEncoder.withIndent('  ').convert(data);
    } catch (_) {
      return data.toString();
    }
  }

  String _formatTime(DateTime value) {
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');
    final second = value.second.toString().padLeft(2, '0');
    return '$hour:$minute:$second';
  }

  int _developerLevel(AppLogLevel level) {
    return switch (level) {
      AppLogLevel.trace => 300,
      AppLogLevel.debug => 500,
      AppLogLevel.info => 800,
      AppLogLevel.warning => 900,
      AppLogLevel.error => 1000,
      AppLogLevel.fatal => 1200,
    };
  }

  AppLogEntry? _tryParseLog(String value) {
    try {
      return AppLogEntry.fromJson(jsonDecode(value) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }
}
