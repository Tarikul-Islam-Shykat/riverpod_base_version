import 'dart:io';

import 'package:flutter/widgets.dart';

enum AppImageSourceType { network, asset, file }

class AppImageSource {
  const AppImageSource._({
    required this.type,
    required this.value,
    this.headers,
  });

  const AppImageSource.network(
    String url, {
    Map<String, String>? headers,
  }) : this._(
         type: AppImageSourceType.network,
         value: url,
         headers: headers,
       );

  const AppImageSource.asset(String assetPath)
    : this._(type: AppImageSourceType.asset, value: assetPath);

  AppImageSource.file(String filePath)
    : this._(type: AppImageSourceType.file, value: filePath);

  final AppImageSourceType type;
  final String value;
  final Map<String, String>? headers;

  String get trimmedValue => value.trim();

  bool get isValid {
    final trimmed = trimmedValue;
    switch (type) {
      case AppImageSourceType.network:
        return trimmed.isNotEmpty &&
            (trimmed.startsWith('http://') || trimmed.startsWith('https://'));
      case AppImageSourceType.asset:
        return trimmed.isNotEmpty;
      case AppImageSourceType.file:
        return trimmed.isNotEmpty && File(trimmed).existsSync();
    }
  }

  ImageProvider<Object> buildImageProvider() {
    switch (type) {
      case AppImageSourceType.network:
        return NetworkImage(trimmedValue, headers: headers);
      case AppImageSourceType.asset:
        return AssetImage(trimmedValue);
      case AppImageSourceType.file:
        return FileImage(File(trimmedValue));
    }
  }
}
