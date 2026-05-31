import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_base/core/services/text-service/text-service.dart';

import '../../domain/entities/comment_entity.dart';
import '../providers/comment_provider.dart';

class CommentsBottomSheet extends ConsumerWidget {
  const CommentsBottomSheet({super.key, required this.postId});

  final int postId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commentsAsync = ref.watch(commentsProvider(postId));

    return Material(
      color: Colors.white,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: headingText(
                        text: 'Comments',
                        color: Colors.black87,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: commentsAsync.when(
                  loading: () => const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  error: (error, stackTrace) {
                    return Padding(
                      padding: const EdgeInsets.all(24),
                      child: normalText(
                        text: error.toString(),
                        textAlign: TextAlign.center,
                        color: Colors.red.shade700,
                        maxLines: 6,
                      ),
                    );
                  },
                  data: (comments) {
                    if (comments.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.all(24),
                        child: normalText(
                          text: 'No comments found',
                          textAlign: TextAlign.center,
                          color: Colors.black54,
                        ),
                      );
                    }

                    return ListView.separated(
                      shrinkWrap: true,
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                      itemCount: comments.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final comment = comments[index];
                        return _CommentCard(comment: comment);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CommentCard extends StatelessWidget {
  const _CommentCard({required this.comment});

  final CommentEntity comment;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.8,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            headingText(
              text: comment.name,
              color: Colors.black87,
              maxLines: 2,
            ),
            const SizedBox(height: 8),
            smallText(
              text: comment.email,
              color: Colors.grey.shade600,
            ),
            const SizedBox(height: 12),
            normalText(
              text: comment.body,
              color: Colors.black87,
              maxLines: 6,
            ),
          ],
        ),
      ),
    );
  }
}
