import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_base/core/services/text-service/text-service.dart';

import '../../domain/entities/post_entity.dart';
import '../providers/posts_provider.dart';

class PostsPage extends ConsumerWidget {
  const PostsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(postsProvider);

    return Scaffold(
      appBar: AppBar(
        title: headingText(
          text: 'Posts',
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
        actions: [
          IconButton(
            onPressed: () => ref.invalidate(postsProvider),
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh posts',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          return ref.refresh(postsProvider.future).then((_) {});
        },
        child: postsAsync.when(
          loading: () => ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              const SizedBox(height: 250),
              const Center(child: CircularProgressIndicator()),
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
                  text: 'Failed to load posts',
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
          data: (posts) {
            if (posts.isEmpty) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  const SizedBox(height: 200),
                  Center(
                    child: normalText(
                      text: 'No posts found',
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
              itemCount: posts.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final post = posts[index];
                return _PostCard(post: post);
              },
            );
          },
        ),
      ),
    );
  }
}

class _PostCard extends StatelessWidget {
  const _PostCard({required this.post});

  final PostEntity post;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.5,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            headingText(
              text: post.title,
              maxLines: 3,
              color: Colors.black87,
            ),
            const SizedBox(height: 8),
            normalText(
              text: post.body,
              maxLines: 6,
              color: Colors.black87,
            ),
            const SizedBox(height: 12),
            smallText(
              text: 'Post #${post.id} • User #${post.userId}',
              color: Colors.grey.shade600,
            ),
          ],
        ),
      ),
    );
  }
}
