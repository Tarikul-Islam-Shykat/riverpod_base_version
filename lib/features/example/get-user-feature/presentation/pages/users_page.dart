import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_base/core/services/text-service/text-service.dart';

import '../providers/user_provider.dart';
import '../widgets/comments_bottom_sheet.dart';
import '../widgets/user_card.dart';

class UsersPage extends ConsumerWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(usersProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: headingText(
          text: 'Users',
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
        actions: [
          IconButton(
            onPressed: () => ref.invalidate(usersProvider),
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh users',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          return ref.refresh(usersProvider.future).then((_) {});
        },
        child: usersAsync.when(
          loading: () => ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: const [
              SizedBox(height: 250),
              Center(child: CircularProgressIndicator()),
            ],
          ),
          error: (error, stackTrace) {
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(24),
              children: [
                const SizedBox(height: 80),
                Icon(
                  Icons.error_outline_rounded,
                  color: Colors.red.shade400,
                  size: 56,
                ),
                const SizedBox(height: 16),
                headingText(
                  text: 'Failed to load users',
                  textAlign: TextAlign.center,
                  color: Colors.black87,
                ),
                const SizedBox(height: 12),
                normalText(
                  text: error.toString(),
                  textAlign: TextAlign.center,
                  maxLines: 8,
                  color: Colors.black54,
                ),
              ],
            );
          },
          data: (users) {
            if (users.isEmpty) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  const SizedBox(height: 200),
                  Center(
                    child: normalText(
                      text: 'No users found',
                      textAlign: TextAlign.center,
                      color: Colors.black54,
                    ),
                  ),
                ],
              );
            }

            return ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: users.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final user = users[index];
                return UserCard(
                  user: user,
                  onTap: () => _openCommentsSheet(context, user.id),
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _openCommentsSheet(BuildContext context, int postId) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.85,
        child: CommentsBottomSheet(postId: postId),
      ),
    );
  }
}
