import 'package:flutter/material.dart';

abstract class AppImageShape {
  const AppImageShape();

  const factory AppImageShape.rounded({double radius}) = RoundedImageShape;
  const factory AppImageShape.circle() = CircleImageShape;

  Widget clip({
    required Widget child,
    double? width,
    double? height,
  });
}

class RoundedImageShape implements AppImageShape {
  const RoundedImageShape({this.radius = 8});

  final double radius;

  @override
  Widget clip({
    required Widget child,
    double? width,
    double? height,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: child,
    );
  }
}

class CircleImageShape implements AppImageShape {
  const CircleImageShape();

  @override
  Widget clip({
    required Widget child,
    double? width,
    double? height,
  }) {
    final squareSize = _resolveSquareSize(width, height);
    Widget shapedChild = child;

    if (squareSize != null) {
      shapedChild = SizedBox(
        width: squareSize,
        height: squareSize,
        child: FittedBox(
          fit: BoxFit.cover,
          clipBehavior: Clip.hardEdge,
          child: SizedBox(
            width: width ?? squareSize,
            height: height ?? squareSize,
            child: child,
          ),
        ),
      );
    }

    return ClipOval(child: shapedChild);
  }

  double? _resolveSquareSize(double? width, double? height) {
    if (width != null && height != null) {
      return width < height ? width : height;
    }
    return width ?? height;
  }
}
