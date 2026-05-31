import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_base/core/constants/app_colors.dart';
import 'package:riverpod_base/core/router/app_router.dart';
import 'package:riverpod_base/core/services/spacing_service/app_spacing.dart';
import 'package:riverpod_base/core/services/text-service/text-service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F9),
      appBar: AppBar(
        title: headingText(
          text: 'Riverpod Base',
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
        backgroundColor: AppColors.primary,
      ),
      body: Center(
        child: Padding(
          padding: AppSpacing.sectionPadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              headingText(
                text: 'Learn Riverpod with a real feature',
                textAlign: TextAlign.center,
                maxLines: 2,
                color: Colors.black87,
              ),
              AppSpacing.verticalSm,
              normalText(
                text:
                    'Open the posts feature and practice feature-based Riverpod development.',
                textAlign: TextAlign.center,
                maxLines: 3,
                color: Colors.black54,
              ),
              AppSpacing.verticalXxl,
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () => context.go(AppRoutes.posts),
                  child: smallText(
                    text: 'Open Posts Feature',
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
