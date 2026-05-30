import 'package:flutter/material.dart';
import 'package:riverpod_base/shared/dialog/standard_dialog.dart';

/// Usage example:
///
/// await showLogoutDialog(
///   context: context,
///   onConfirm: () {
///     // Clear session and navigate to login.
///   },
/// );
Future<bool?> showLogoutDialog({
  required BuildContext context,
  String title = 'Log out?',
  String message =
      'You will need to sign in again to continue using your account.',
  String confirmText = 'Log out',
  String cancelText = 'Stay',
  VoidCallback? onConfirm,
  VoidCallback? onCancel,
  bool barrierDismissible = true,
}) {
  return showStandardDialog(
    context: context,
    title: title,
    message: message,
    confirmText: confirmText,
    cancelText: cancelText,
    type: StandardDialogType.warning,
    icon: Icons.logout_rounded,
    onConfirm: onConfirm,
    onCancel: onCancel,
    barrierDismissible: barrierDismissible,
  );
}
