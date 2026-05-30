import 'package:flutter/material.dart';
import 'package:riverpod_base/shared/dialog/standard_dialog.dart';

/// Usage example:
///
/// await showDeleteConfirmationDialog(
///   context: context,
///   itemName: 'Profile photo',
///   onConfirm: () {
///     // Delete item here.
///   },
/// );
Future<bool?> showDeleteConfirmationDialog({
  required BuildContext context,
  String? itemName,
  String title = 'Delete item?',
  String? message,
  String confirmText = 'Delete',
  String cancelText = 'Cancel',
  VoidCallback? onConfirm,
  VoidCallback? onCancel,
  bool barrierDismissible = true,
}) {
  final resolvedMessage = message ??
      (itemName == null
          ? 'This action cannot be undone. Please confirm before deleting.'
          : 'This will permanently delete $itemName. This action cannot be undone.');

  return showStandardDialog(
    context: context,
    title: title,
    message: resolvedMessage,
    confirmText: confirmText,
    cancelText: cancelText,
    type: StandardDialogType.danger,
    icon: Icons.delete_outline_rounded,
    onConfirm: onConfirm,
    onCancel: onCancel,
    barrierDismissible: barrierDismissible,
  );
}
