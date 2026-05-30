import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
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
              'Dialog Review',
              style: textTheme.headlineMedium,
            ),
            AppSpacing.verticalSm,
            Text(
              'Use the buttons below to preview each reusable dialog.',
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
