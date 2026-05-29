# Image View Module

Reusable image widgets for network, asset, and local file images.

## Features

- Supports `network`, `asset`, and `file` image sources
- Uses `flutter_screenutil` for responsive sizing
- Keeps full-screen preview logic separate from the main widget
- Uses `memCacheWidth` and `memCacheHeight` to reduce memory pressure
- Makes shapes extensible through a dedicated shape API

## Main Widget

Use `ResponsiveImageView` for most image rendering cases.

```dart
ResponsiveImageView(
  source: AppImageSource.network(shop.coverImage),
  shape: AppImageShape.rounded(radius: 12),
  widthRatio: 0.9,
  height: 180,
)
```

## Source Types

```dart
AppImageSource.network('https://example.com/image.jpg')
AppImageSource.asset('assets/images/banner.png')
AppImageSource.file('/storage/emulated/0/Download/avatar.jpg')
```

## Shapes

```dart
AppImageShape.rounded(radius: 16)
AppImageShape.circle()
```

Add a new shape by implementing `AppImageShape`.

## Full Screen

Set `enableFullScreenView: true` to open the image in a dedicated viewer page.

## Cache Sizing

The widget computes `memCacheWidth` and `memCacheHeight` from the rendered size
and device pixel ratio. This helps reduce unnecessary image memory usage while
keeping the image output sharp.
