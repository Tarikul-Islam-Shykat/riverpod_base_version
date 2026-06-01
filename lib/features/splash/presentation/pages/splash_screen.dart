import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/router/app_router.dart';
import '../../../../../core/services/text-service/text-service.dart';
import '../../domain/entities/splash_session_entity.dart';
import '../providers/splash_provider.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  void _navigate(BuildContext context, SplashSessionEntity session) {
    if (!session.isAuthenticated) {
      context.go(AppRoutes.login);
      return;
    }

    if (session.isAdmin) {
      context.go(AppRoutes.users);
      return;
    }

    context.go(AppRoutes.profile);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(splashProvider, (previous, next) {
      next.whenOrNull(
        data: (session) => _navigate(context, session),
      );
    });

    final splashAsync = ref.watch(splashProvider);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.gradientColor),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 110,
                    width: 110,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: const Icon(
                      Icons.auto_awesome_rounded,
                      color: Colors.white,
                      size: 56,
                    ),
                  ),
                  const SizedBox(height: 24),
                  headingText(
                    text: 'Riverpod Base',
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                  const SizedBox(height: 8),
                  smallText(
                    text: 'Checking session and preparing your app...',
                    color: Colors.white.withValues(alpha: 0.9),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 28),
                  splashAsync.when(
                    loading: () => const CircularProgressIndicator(
                      color: Colors.white,
                    ),
                    error: (error, stackTrace) => Column(
                      children: [
                        normalText(
                          text: 'Loading fallback route',
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                        const SizedBox(height: 12),
                        const CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      ],
                    ),
                    data: (destination) => Column(
                      children: [
                        smallText(
                          text: destination.isAuthenticated
                              ? (destination.isAdmin
                                  ? 'Preparing admin session...'
                                  : 'Preparing user session...')
                              : 'No session found...',
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                        const SizedBox(height: 12),
                        const CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      ],
                    ),
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
