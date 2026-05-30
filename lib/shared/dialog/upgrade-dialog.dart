import 'package:flutter/material.dart';
import 'package:riverpod_base/core/constants/app_texts.dart';
import 'package:riverpod_base/shared/dialog/standard_dialog.dart';

/// Usage example:
///
/// await showUpgradeDialog(
///   context: context,
///   onConfirm: () {
///     // Open app store, play store, or upgrade flow.
///   },
/// );
Future<bool?> showUpgradeDialog({
  required BuildContext context,
  String title = 'Update available',
  String? message,
  String confirmText = 'Update now',
  String cancelText = 'Later',
  VoidCallback? onConfirm,
  VoidCallback? onCancel,
  bool forceUpdate = false,
  bool barrierDismissible = true,
}) {
  return showStandardDialog(
    context: context,
    title: title,
    message: message ??
        'A newer version of ${AppTexts.appName} is available with improvements and fixes.',
    confirmText: confirmText,
    cancelText: cancelText,
    type: StandardDialogType.success,
    icon: Icons.system_update_alt_rounded,
    showCancelButton: !forceUpdate,
    onConfirm: onConfirm,
    onCancel: onCancel,
    barrierDismissible: forceUpdate ? false : barrierDismissible,
  );
}
