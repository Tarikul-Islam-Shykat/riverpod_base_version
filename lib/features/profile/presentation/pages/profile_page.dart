import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/services/text-service/text-service.dart';
import '../providers/profile_provider.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);

    return Scaffold(
      appBar: AppBar(
        title: headingText(text: 'Profile'),
        actions: [
          IconButton(
            onPressed: () => ref.invalidate(profileProvider),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: normalText(
              text: error.toString(),
              textAlign: TextAlign.center,
              maxLines: 4,
            ),
          ),
        ),
        data: (profile) => ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Center(
              child: CircleAvatar(
                radius: 52,
                backgroundImage: profile.image == null || profile.image!.isEmpty
                    ? null
                    : NetworkImage(profile.image!),
                child: profile.image == null || profile.image!.isEmpty
                    ? const Icon(Icons.person, size: 48)
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            headingText(
              text: profile.fullName ?? 'No name',
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
            const SizedBox(height: 8),
            smallText(
              text: profile.email ?? 'No email',
              textAlign: TextAlign.center,
              color: Colors.black54,
            ),
            const SizedBox(height: 24),
            _ProfileInfoTile(
              label: 'Gems',
              value: profile.gems?.toString() ?? '0',
            ),
            _ProfileInfoTile(
              label: 'Active plan',
              value: profile.activePlan == true ? 'Yes' : 'No',
            ),
            _ProfileInfoTile(
              label: 'Blocked',
              value: profile.isBlocked == true ? 'Yes' : 'No',
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.push(AppRoutes.editProfile),
              icon: const Icon(Icons.edit),
              label: const Text('Edit Profile'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileInfoTile extends StatelessWidget {
  const _ProfileInfoTile({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: smallText(text: label, color: Colors.black54),
      trailing: normalText(text: value, fontWeight: FontWeight.w600),
    );
  }
}
