import 'package:flutter/material.dart';
import 'package:riverpod_base/shared/dialog/standard_dialog.dart';

/// Usage example:
///
/// await showUnderConstructionDialog(
///   context: context,
/// );
Future<bool?> showUnderConstructionDialog({
  required BuildContext context,
  String title = 'Coming soon',
  String message =
      'This feature is currently under construction. Please check back later.',
  String confirmText = 'Got it',
  VoidCallback? onConfirm,
  bool barrierDismissible = true,
}) {
  return showStandardDialog(
    context: context,
    title: title,
    message: message,
    confirmText: confirmText,
    type: StandardDialogType.info,
    icon: Icons.construction_rounded,
    showCancelButton: false,
    onConfirm: onConfirm,
    barrierDismissible: barrierDismissible,
  );
}
