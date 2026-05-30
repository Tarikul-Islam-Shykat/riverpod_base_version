import 'package:flutter/material.dart';
import 'package:riverpod_base/shared/dialog/standard_dialog.dart';

/// Usage example:
///
/// await showUnderMaintenanceDialog(
///   context: context,
///   message: 'Payments are temporarily unavailable while we improve the service.',
/// );
Future<bool?> showUnderMaintenanceDialog({
  required BuildContext context,
  String title = 'Under maintenance',
  String message =
      'We are making a few improvements right now. Please try again shortly.',
  String confirmText = 'Okay',
  VoidCallback? onConfirm,
  bool barrierDismissible = true,
}) {
  return showStandardDialog(
    context: context,
    title: title,
    message: message,
    confirmText: confirmText,
    type: StandardDialogType.warning,
    icon: Icons.handyman_rounded,
    showCancelButton: false,
    onConfirm: onConfirm,
    barrierDismissible: barrierDismissible,
  );
}
