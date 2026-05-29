import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'image_shapes.dart';
import 'image_source.dart';
import 'image_viewer_page.dart';

class ResponsiveImageView extends StatelessWidget {
  const ResponsiveImageView({
    super.key,
    required this.source,
    this.shape = const AppImageShape.rounded(),
    this.width,
    this.height,
    this.widthRatio,
    this.heightRatio,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
    this.placeholder,
    this.errorWidget,
    this.enableFullScreenView = false,
    this.onTap,
    this.backgroundColor,
    this.cacheWidth,
    this.cacheHeight,
  });

  final AppImageSource source;
  final AppImageShape shape;
  final double? width;
  final double? height;
  final double? widthRatio;
  final double? heightRatio;
  final BoxFit fit;
  final Alignment alignment;
  final Widget? placeholder;
  final Widget? errorWidget;
  final bool enableFullScreenView;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final int? cacheWidth;
  final int? cacheHeight;

  @override
  Widget build(BuildContext context) {
    final resolvedWidth = _resolveWidth();
    final resolvedHeight = _resolveHeight();
    final memCacheWidth = cacheWidth ?? _toMemCacheSize(context, resolvedWidth);
    final memCacheHeight =
        cacheHeight ?? _toMemCacheSize(context, resolvedHeight);

    final imageWidget = source.isValid
        ? _buildImage(
            resolvedWidth: resolvedWidth,
            resolvedHeight: resolvedHeight,
            memCacheWidth: memCacheWidth,
            memCacheHeight: memCacheHeight,
          )
        : _buildErrorContainer(resolvedWidth, resolvedHeight);

    final clippedImage = shape.clip(
      child: imageWidget,
      width: resolvedWidth,
      height: resolvedHeight,
    );

    final sizedImage = SizedBox(
      width: resolvedWidth,
      height: resolvedHeight,
      child: clippedImage,
    );

    if (!enableFullScreenView && onTap == null) {
      return sizedImage;
    }

    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap!.call();
          return;
        }

        if (enableFullScreenView && source.isValid) {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder:
                  (_) => ImageViewerPage(
                    source: source,
                    loadingBuilder:
                        placeholder == null ? null : (_) => placeholder!,
                    errorWidget: errorWidget,
                  ),
            ),
          );
        }
      },
      child: sizedImage,
    );
  }

  double? _resolveWidth() {
    if (widthRatio != null) {
      return ScreenUtil().screenWidth * widthRatio!;
    }
    return width?.w;
  }

  double? _resolveHeight() {
    if (heightRatio != null) {
      return ScreenUtil().screenHeight * heightRatio!;
    }
    return height?.h;
  }

  int? _toMemCacheSize(BuildContext context, double? logicalSize) {
    if (logicalSize == null) {
      return null;
    }

    final pixelRatio = MediaQuery.devicePixelRatioOf(context);
    final computedSize = (logicalSize * pixelRatio).round();
    return computedSize > 0 ? computedSize : null;
  }

  Widget _buildImage({
    required double? resolvedWidth,
    required double? resolvedHeight,
    required int? memCacheWidth,
    required int? memCacheHeight,
  }) {
    switch (source.type) {
      case AppImageSourceType.network:
        return CachedNetworkImage(
          imageUrl: source.trimmedValue,
          width: resolvedWidth,
          height: resolvedHeight,
          fit: fit,
          alignment: alignment,
          memCacheWidth: memCacheWidth,
          memCacheHeight: memCacheHeight,
          httpHeaders: source.headers,
          placeholder:
              (context, url) => _buildPlaceholder(resolvedWidth, resolvedHeight),
          errorWidget: (context, url, error) =>
              _buildErrorContainer(resolvedWidth, resolvedHeight),
        );
      case AppImageSourceType.asset:
        return Image.asset(
          source.trimmedValue,
          width: resolvedWidth,
          height: resolvedHeight,
          fit: fit,
          alignment: alignment,
          cacheWidth: memCacheWidth,
          cacheHeight: memCacheHeight,
          errorBuilder: (context, error, stackTrace) =>
              _buildErrorContainer(resolvedWidth, resolvedHeight),
        );
      case AppImageSourceType.file:
        return Image.file(
          File(source.trimmedValue),
          width: resolvedWidth,
          height: resolvedHeight,
          fit: fit,
          alignment: alignment,
          cacheWidth: memCacheWidth,
          cacheHeight: memCacheHeight,
          errorBuilder: (context, error, stackTrace) =>
              _buildErrorContainer(resolvedWidth, resolvedHeight),
        );
    }
  }

  Widget _buildPlaceholder(double? width, double? height) {
    return SizedBox(
      width: width,
      height: height,
      child:
          placeholder ??
          const Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2.4),
            ),
          ),
    );
  }

  Widget _buildErrorContainer(double? width, double? height) {
    return Container(
      width: width,
      height: height,
      color: backgroundColor ?? Colors.grey.shade200,
      alignment: Alignment.center,
      child:
          errorWidget ??
          Icon(
            Icons.broken_image_outlined,
            color: Colors.grey.shade500,
            size: 28.sp,
          ),
    );
  }
}
