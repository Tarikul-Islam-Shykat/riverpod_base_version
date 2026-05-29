import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'image_source.dart';

class ImageViewerPage extends StatelessWidget {
  const ImageViewerPage({
    super.key,
    required this.source,
    this.backgroundColor = Colors.black,
    this.loadingBuilder,
    this.errorWidget,
  });

  final AppImageSource source;
  final Color backgroundColor;
  final WidgetBuilder? loadingBuilder;
  final Widget? errorWidget;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          Center(
            child: InteractiveViewer(
              minScale: 0.5,
              maxScale: 4,
              child: _buildImage(context),
            ),
          ),
          Positioned(
            top: MediaQuery.paddingOf(context).top + 8,
            right: 8,
            child: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    switch (source.type) {
      case AppImageSourceType.network:
        return CachedNetworkImage(
          imageUrl: source.trimmedValue,
          fit: BoxFit.contain,
          httpHeaders: source.headers,
          placeholder: (context, url) => _buildLoading(context),
          errorWidget: (context, url, error) => _buildError(),
        );
      case AppImageSourceType.asset:
        return Image.asset(
          source.trimmedValue,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => _buildError(),
        );
      case AppImageSourceType.file:
        return Image.file(
          File(source.trimmedValue),
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => _buildError(),
        );
    }
  }

  Widget _buildLoading(BuildContext context) {
    return loadingBuilder?.call(context) ??
        const SizedBox(
          width: 32,
          height: 32,
          child: CircularProgressIndicator(color: Colors.white),
        );
  }

  Widget _buildError() {
    return errorWidget ??
        const Center(
          child: Icon(Icons.broken_image_outlined, color: Colors.white, size: 64),
        );
  }
}
