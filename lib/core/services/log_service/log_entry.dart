enum AppLogLevel {
  trace,
  debug,
  info,
  warning,
  error,
  fatal;

  String get label {
    return switch (this) {
      AppLogLevel.trace => 'Trace',
      AppLogLevel.debug => 'Debug',
      AppLogLevel.info => 'Info',
      AppLogLevel.warning => 'Warning',
      AppLogLevel.error => 'Error',
      AppLogLevel.fatal => 'Fatal',
    };
  }

  String get emoji {
    return switch (this) {
      AppLogLevel.trace => '🔎',
      AppLogLevel.debug => '🐞',
      AppLogLevel.info => 'ℹ️',
      AppLogLevel.warning => '⚠️',
      AppLogLevel.error => '❌',
      AppLogLevel.fatal => '🔥',
    };
  }
}

class AppLogEntry {
  const AppLogEntry({
    required this.id,
    required this.level,
    required this.message,
    required this.timestamp,
    this.tag,
    this.details,
    this.error,
    this.stackTrace,
    this.sourceFilePath,
    this.sourceLineNumber,
    this.sourceColumnNumber,
  });

  final String id;
  final AppLogLevel level;
  final String message;
  final DateTime timestamp;
  final String? tag;
  final String? details;
  final String? error;
  final String? stackTrace;
  final String? sourceFilePath;
  final int? sourceLineNumber;
  final int? sourceColumnNumber;

  String? get sourceLocation {
    final filePath = sourceFilePath;
    final lineNumber = sourceLineNumber;

    if (filePath == null || lineNumber == null) {
      return null;
    }

    final buffer = StringBuffer('$filePath:$lineNumber');
    if (sourceColumnNumber != null) {
      buffer.write(':$sourceColumnNumber');
    }
    return buffer.toString();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'level': level.name,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'tag': tag,
      'details': details,
      'error': error,
      'stackTrace': stackTrace,
      'sourceFilePath': sourceFilePath,
      'sourceLineNumber': sourceLineNumber,
      'sourceColumnNumber': sourceColumnNumber,
    };
  }

  factory AppLogEntry.fromJson(Map<String, dynamic> json) {
    return AppLogEntry(
      id: json['id'] as String,
      level: AppLogLevel.values.byName(json['level'] as String),
      message: json['message'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      tag: json['tag'] as String?,
      details: json['details'] as String?,
      error: json['error'] as String?,
      stackTrace: json['stackTrace'] as String?,
      sourceFilePath: json['sourceFilePath'] as String?,
      sourceLineNumber: json['sourceLineNumber'] as int?,
      sourceColumnNumber: json['sourceColumnNumber'] as int?,
    );
  }
}
