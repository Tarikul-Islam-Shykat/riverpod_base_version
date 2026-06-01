import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/dialog/delete-confirmation-dialog.dart';
import '../spacing_service/app_spacing.dart';
import '../text-service/text-service.dart';
import 'log_entry.dart';
import 'log_service.dart';

class LogViewerScreen extends ConsumerWidget {
  const LogViewerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logsAsync = ref.watch(appLogsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('App Logs'),
        actions: [
          IconButton(
            tooltip: 'Clear logs',
            onPressed: () async {
              final confirmed = await showDeleteConfirmationDialog(
                context: context,
                itemName: 'all saved logs',
                title: 'Clear all logs?',
                confirmText: 'Clear',
              );

              if (confirmed == true && context.mounted) {
                await ref.read(appLoggerServiceProvider).clear();
              }
            },
            icon: const Icon(Icons.delete_outline_rounded),
          ),
        ],
      ),
      body: logsAsync.when(
        data: (logs) {
          if (logs.isEmpty) {
            return Center(
              child: Padding(
                padding: AppSpacing.sectionPadding,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.receipt_long_outlined,
                      size: 48,
                      color: Colors.grey.shade500,
                    ),
                    AppSpacing.verticalLg,
                    headingText(
                      text: 'No logs yet',
                      textAlign: TextAlign.center,
                      color: Colors.black87,
                    ),
                    AppSpacing.verticalSm,
                    normalText(
                      text:
                          'Generate a few logs from the preview screen and they will appear here.',
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      color: Colors.black54,
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.separated(
            padding: AppSpacing.sectionPadding,
            itemBuilder: (context, index) => _LogCard(entry: logs[index]),
            separatorBuilder: (context, index) => AppSpacing.verticalMd,
            itemCount: logs.length,
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) {
          return Center(
            child: Padding(
              padding: AppSpacing.sectionPadding,
              child: normalText(
                text: 'Unable to load logs.\n$error',
                textAlign: TextAlign.center,
                maxLines: 6,
                color: Colors.red.shade700,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _LogCard extends StatelessWidget {
  const _LogCard({required this.entry});

  final AppLogEntry entry;

  @override
  Widget build(BuildContext context) {
    final accent = _levelColor(entry.level);

    return Container(
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppSpacing.radiusLg,
        border: Border.all(color: accent.withValues(alpha: 0.18)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.12),
                  borderRadius: AppSpacing.radiusMd,
                ),
                child: Center(
                  child: Text(
                    entry.level.emoji,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
              AppSpacing.horizontalMd,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    headingText(
                      text: entry.message,
                      color: Colors.black87,
                      maxLines: 3,
                    ),
                    AppSpacing.verticalXs,
                    smallText(
                      text:
                          '${entry.level.label.toUpperCase()} • ${_formatDate(entry.timestamp)}'
                          '${entry.tag == null ? '' : ' • ${entry.tag}'}',
                      maxLines: 2,
                      color: Colors.black54,
                    ),
                    if (entry.sourceLocation != null) ...[
                      AppSpacing.verticalXs,
                      SelectableText(
                        entry.sourceLocation!,
                        style: TextStyle(
                          color: Colors.black45,
                          fontSize: 11,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          if (entry.details != null) ...[
            AppSpacing.verticalLg,
            _LogSection(
              title: 'Details',
              content: entry.details!,
              accent: accent,
            ),
          ],
          if (entry.error != null) ...[
            AppSpacing.verticalLg,
            _LogSection(
              title: 'Error',
              content: entry.error!,
              accent: Colors.red.shade600,
            ),
          ],
          if (entry.stackTrace != null) ...[
            AppSpacing.verticalLg,
            _LogSection(
              title: 'Stack Trace',
              content: entry.stackTrace!,
              accent: Colors.deepOrange.shade400,
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(DateTime value) {
    final year = value.year.toString();
    final month = value.month.toString().padLeft(2, '0');
    final day = value.day.toString().padLeft(2, '0');
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');
    final second = value.second.toString().padLeft(2, '0');
    return '$year-$month-$day $hour:$minute:$second';
  }

  Color _levelColor(AppLogLevel level) {
    return switch (level) {
      AppLogLevel.trace => Colors.blueGrey,
      AppLogLevel.debug => Colors.indigo,
      AppLogLevel.info => Colors.blue,
      AppLogLevel.warning => Colors.orange,
      AppLogLevel.error => Colors.red,
      AppLogLevel.fatal => Colors.deepPurple,
    };
  }
}

class _LogSection extends StatelessWidget {
  const _LogSection({
    required this.title,
    required this.content,
    required this.accent,
  });

  final String title;
  final String content;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.06),
        borderRadius: AppSpacing.radiusMd,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          smallText(
            text: title,
            color: accent,
            fontWeight: FontWeight.w600,
          ),
          AppSpacing.verticalSm,
          SelectableText(
            content,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 12,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
