import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:riverpod_base/core/constants/app_colors.dart';
import 'package:riverpod_base/core/services/spacing_service/app_spacing.dart';
import 'package:riverpod_base/core/services/text-service/text-service.dart';

/// Usage example:
///
/// await showStandardDialog(
///   context: context,
///   title: 'Confirm action?',
///   message: 'Please confirm before continuing.',
///   onConfirm: () {
///     // Run confirm action.
///   },
/// );
enum StandardDialogType { info, success, warning, danger }

Future<bool?> showStandardDialog({
  required BuildContext context,
  required String title,
  required String message,
  String confirmText = 'Confirm',
  String cancelText = 'Cancel',
  VoidCallback? onConfirm,
  VoidCallback? onCancel,
  StandardDialogType type = StandardDialogType.info,
  IconData? icon,
  bool barrierDismissible = true,
  bool showCancelButton = true,
}) {
  return showGeneralDialog<bool>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black.withValues(alpha: 0.45),
    transitionDuration: const Duration(milliseconds: 220),
    pageBuilder: (context, animation, secondaryAnimation) {
      return StandardDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        onConfirm: onConfirm,
        onCancel: onCancel,
        type: type,
        icon: icon,
        showCancelButton: showCancelButton,
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );

      return FadeTransition(
        opacity: curvedAnimation,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.96, end: 1).animate(curvedAnimation),
          child: child,
        ),
      );
    },
  );
}

class StandardDialog extends StatelessWidget {
  const StandardDialog({
    super.key,
    required this.title,
    required this.message,
    required this.confirmText,
    required this.cancelText,
    required this.type,
    required this.showCancelButton,
    this.onConfirm,
    this.onCancel,
    this.icon,
  });

  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final StandardDialogType type;
  final IconData? icon;
  final bool showCancelButton;

  @override
  Widget build(BuildContext context) {
    final accentColor = _DialogStyle.accentColor(type);
    final dialogIcon = icon ?? _DialogStyle.icon(type);

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
      child: Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: DialogSpacing.inset),
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: DialogSpacing.maxWidth),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(DialogSpacing.dialogRadius),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 32.r,
                  offset: Offset(0, 18.h),
                ),
              ],
            ),
            child: Padding(
              padding: DialogSpacing.padding,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _DialogIcon(icon: dialogIcon, color: accentColor),
                  SizedBox(height: DialogSpacing.iconToTitle),
                  headingText(
                    text: title,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    color: const Color(0xFF111827),
                  ),
                  SizedBox(height: DialogSpacing.titleToMessage),
                  normalText(
                    text: message,
                    textAlign: TextAlign.center,
                    maxLines: 6,
                    color: const Color(0xFF6B7280),
                  ),
                  SizedBox(height: DialogSpacing.messageToActions),
                  _DialogActions(
                    confirmText: confirmText,
                    cancelText: cancelText,
                    accentColor: accentColor,
                    showCancelButton: showCancelButton,
                    onConfirm: () {
                      Navigator.of(context).pop(true);
                      onConfirm?.call();
                    },
                    onCancel: () {
                      Navigator.of(context).pop(false);
                      onCancel?.call();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DialogIcon extends StatelessWidget {
  const _DialogIcon({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: DialogSpacing.iconSize,
      height: DialogSpacing.iconSize,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(icon, color: color, size: DialogSpacing.iconInnerSize),
      ),
    );
  }
}

class _DialogActions extends StatelessWidget {
  const _DialogActions({
    required this.confirmText,
    required this.cancelText,
    required this.accentColor,
    required this.showCancelButton,
    required this.onConfirm,
    required this.onCancel,
  });

  final String confirmText;
  final String cancelText;
  final Color accentColor;
  final bool showCancelButton;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final actions = [
      if (showCancelButton)
        Expanded(
          child: _DialogButton(
            text: cancelText,
            onTap: onCancel,
            foregroundColor: const Color(0xFF374151),
            backgroundColor: const Color(0xFFF3F4F6),
          ),
        ),
      if (showCancelButton) SizedBox(width: DialogSpacing.actionGap),
      Expanded(
        child: _DialogButton(
          text: confirmText,
          onTap: onConfirm,
          foregroundColor: Colors.white,
          backgroundColor: accentColor,
          gradient:
              accentColor == AppColors.primary ? AppColors.gradientColor : null,
        ),
      ),
    ];

    return Row(children: actions);
  }
}

class _DialogButton extends StatelessWidget {
  const _DialogButton({
    required this.text,
    required this.onTap,
    required this.foregroundColor,
    required this.backgroundColor,
    this.gradient,
  });

  final String text;
  final VoidCallback onTap;
  final Color foregroundColor;
  final Color backgroundColor;
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(DialogSpacing.buttonRadius),
        child: Ink(
          height: DialogSpacing.buttonHeight,
          decoration: BoxDecoration(
            color: backgroundColor,
            gradient: gradient,
            borderRadius: BorderRadius.circular(DialogSpacing.buttonRadius),
          ),
          child: Center(
            child: normalText(
              text: text,
              color: foregroundColor,
              fontWeight: FontWeight.w600,
              textAlign: TextAlign.center,
              maxLines: 1,
            ),
          ),
        ),
      ),
    );
  }
}

class _DialogStyle {
  const _DialogStyle._();

  static Color accentColor(StandardDialogType type) {
    return switch (type) {
      StandardDialogType.info => AppColors.primary,
      StandardDialogType.success => const Color(0xFF16A34A),
      StandardDialogType.warning => const Color(0xFFF59E0B),
      StandardDialogType.danger => const Color(0xFFEF4444),
    };
  }

  static IconData icon(StandardDialogType type) {
    return switch (type) {
      StandardDialogType.info => Icons.info_outline_rounded,
      StandardDialogType.success => Icons.check_rounded,
      StandardDialogType.warning => Icons.warning_amber_rounded,
      StandardDialogType.danger => Icons.delete_outline_rounded,
    };
  }
}
