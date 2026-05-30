import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:riverpod_base/core/services/log_service/log_service_exports.dart';
import 'package:riverpod_base/core/services/spacing_service/app_spacing.dart';
import 'package:riverpod_base/shared/dialog/dialogs.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

final counterProvider = NotifierProvider<CounterNotifier, int>(
  CounterNotifier.new,
);

class CounterNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void increment() => state++;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MaterialApp(
        title: 'Riverpod Base',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1F8A70)),
        ),
        home: const MyHomePage(title: 'Riverpod Counter'),
      ),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counter = ref.watch(counterProvider);
    final textTheme = Theme.of(context).textTheme;
    final logger = ref.read(appLoggerServiceProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.sectionPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Dialog and Log Review',
              style: textTheme.headlineMedium,
            ),
            AppSpacing.verticalSm,
            Text(
              'Preview the reusable dialogs and test the in-app logger from one place.',
              style: textTheme.bodyMedium,
            ),
            AppSpacing.verticalXxl,
            Container(
              padding: AppSpacing.cardPadding,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: AppSpacing.radiusLg,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 18,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Riverpod Counter',
                    style: textTheme.titleMedium,
                  ),
                  AppSpacing.verticalSm,
                  Text(
                    'Current count: $counter',
                    style: textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
            AppSpacing.verticalXxl,
            _PreviewButton(
              label: 'Delete Confirmation Dialog',
              onPressed: () {
                showDeleteConfirmationDialog(
                  context: context,
                  itemName: 'this draft project',
                  onConfirm: () {},
                );
              },
            ),
            AppSpacing.verticalMd,
            _PreviewButton(
              label: 'Logout Dialog',
              onPressed: () {
                showLogoutDialog(
                  context: context,
                  onConfirm: () {},
                );
              },
            ),
            AppSpacing.verticalMd,
            _PreviewButton(
              label: 'Under Construction Dialog',
              onPressed: () {
                showUnderConstructionDialog(context: context);
              },
            ),
            AppSpacing.verticalMd,
            _PreviewButton(
              label: 'Under Maintenance Dialog',
              onPressed: () {
                showUnderMaintenanceDialog(context: context);
              },
            ),
            AppSpacing.verticalMd,
            _PreviewButton(
              label: 'Upgrade Dialog',
              onPressed: () {
                showUpgradeDialog(
                  context: context,
                  onConfirm: () {},
                );
              },
            ),
            AppSpacing.verticalMd,
            _PreviewButton(
              label: 'Force Upgrade Dialog',
              onPressed: () {
                showUpgradeDialog(
                  context: context,
                  forceUpdate: true,
                  onConfirm: () {},
                );
              },
            ),
            AppSpacing.verticalXxl,
            Text(
              'Logger Actions',
              style: textTheme.titleLarge,
            ),
            AppSpacing.verticalSm,
            Text(
              'These buttons create saved logs and print the same entries to the debug console.',
              style: textTheme.bodyMedium,
            ),
            AppSpacing.verticalXxl,
            _PreviewButton(
              label: 'Trace Log',
              onPressed: () async {
                await logger.t(
                  'Trace log from preview screen',
                  tag: 'Preview',
                  data: {'counter': counter, 'screen': 'main'},
                );
              },
            ),
            AppSpacing.verticalMd,
            _PreviewButton(
              label: 'Debug Log',
              onPressed: () async {
                await logger.d(
                  'Debugging dialog preview state',
                  tag: 'Preview',
                  data: {'dialogsVisible': true, 'counter': counter},
                );
              },
            ),
            AppSpacing.verticalMd,
            _PreviewButton(
              label: 'Info Log with JSON',
              onPressed: () async {
                await logger.i(
                  'Fetched sample response',
                  tag: 'Network',
                  data: {
                    'success': true,
                    'message': 'Sample response',
                    'user': {
                      'id': 1,
                      'name': 'Riverpod Base',
                    },
                  },
                );
              },
            ),
            AppSpacing.verticalMd,
            _PreviewButton(
              label: 'Warning Log',
              onPressed: () async {
                await logger.w(
                  'This is a sample warning log',
                  tag: 'Preview',
                  data: 'Something may need attention soon.',
                );
              },
            ),
            AppSpacing.verticalMd,
            _PreviewButton(
              label: 'Error Log',
              onPressed: () async {
                await logger.e(
                  'Sample error log created from preview screen',
                  tag: 'Preview',
                  error: 'Test error',
                  data: {'statusCode': 500, 'endpoint': '/demo'},
                );
              },
            ),
            AppSpacing.verticalMd,
            _PreviewButton(
              label: 'Fatal Log',
              onPressed: () async {
                try {
                  throw StateError('This is a test fatal failure');
                } catch (error, stackTrace) {
                  await logger.f(
                    'Fatal log captured from preview screen',
                    tag: 'Preview',
                    error: error,
                    stackTrace: stackTrace,
                    data: {'reason': 'manual preview'},
                  );
                }
              },
            ),
            AppSpacing.verticalMd,
            _PreviewButton(
              label: 'Open Log Viewer',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const LogViewerScreen(),
                  ),
                );
              },
            ),
            AppSpacing.verticalMd,
            _PreviewButton(
              label: 'Clear Saved Logs',
              onPressed: () async {
                final confirmed = await showDeleteConfirmationDialog(
                  context: context,
                  itemName: 'all saved logs',
                  title: 'Clear saved logs?',
                  confirmText: 'Clear',
                );

                if (confirmed == true) {
                  await logger.clear();
                }
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ref.read(counterProvider.notifier).increment(),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _PreviewButton extends StatelessWidget {
  const _PreviewButton({
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52.h,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(
          label,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
