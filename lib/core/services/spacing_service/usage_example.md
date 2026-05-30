# Spacing Service Usage Example

This folder keeps reusable spacing, radius, padding, and dialog distance values in one place.
Use these values instead of random `SizedBox` numbers so screens and dialogs feel consistent.

## Why this exists

Most UI spacing should follow a predictable rhythm. This project uses an 8-point style scale:

- `4` for tiny gaps
- `8` for small gaps
- `12` for compact element gaps
- `16` for normal content gaps
- `20` for larger content gaps
- `24` for section and dialog action separation
- `32` for large section separation

The values are exposed through `flutter_screenutil`, so they adapt to the configured design size.

## Basic spacing

```dart
import 'package:riverpod_base/core/services/spacing_service/app_spacing.dart';

Column(
  children: [
    const Text('Title'),
    AppSpacing.verticalSm,
    const Text('Subtitle'),
    AppSpacing.verticalXxl,
    ElevatedButton(
      onPressed: () {},
      child: const Text('Continue'),
    ),
  ],
);
```

## Padding and radius

```dart
Container(
  padding: AppSpacing.cardPadding,
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: AppSpacing.radiusLg,
  ),
  child: const Text('Card content'),
);
```

## Dialog spacing standard

Use `DialogSpacing` when building dialogs. This keeps the visual distance between icon, title,
message, and buttons consistent across delete, logout, upgrade, maintenance, and warning dialogs.

Recommended dialog rhythm:

```text
Icon
18px
Title
10px
Message
24px
Buttons
```

Example:

```dart
Column(
  mainAxisSize: MainAxisSize.min,
  children: [
    Icon(Icons.info_outline, size: DialogSpacing.iconSize),
    SizedBox(height: DialogSpacing.iconToTitle),
    const Text('Delete item?'),
    SizedBox(height: DialogSpacing.titleToMessage),
    const Text('This action cannot be undone.'),
    SizedBox(height: DialogSpacing.messageToActions),
    Row(
      children: [
        Expanded(child: OutlinedButton(onPressed: () {}, child: const Text('Cancel'))),
        SizedBox(width: DialogSpacing.actionGap),
        Expanded(child: ElevatedButton(onPressed: () {}, child: const Text('Delete'))),
      ],
    ),
  ],
);
```

## Rule of thumb

Use `AppSpacing` for general layouts and `DialogSpacing` for dialogs. If a spacing value is used
more than once, add it here with a clear name instead of repeating raw numbers in widgets.
