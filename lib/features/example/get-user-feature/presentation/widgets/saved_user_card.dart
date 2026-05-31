import 'package:flutter/material.dart';
import 'package:riverpod_base/core/services/text-service/text-service.dart';

import '../../domain/entities/local_user_entity.dart';

class SavedUserCard extends StatelessWidget {
  const SavedUserCard({super.key, required this.user});

  final LocalUserEntity user;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: Colors.green.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            smallText(
              text: 'Saved user',
              color: Colors.green.shade800,
            ),
            const SizedBox(height: 8),
            headingText(
              text: user.fullName ?? 'No name',
              maxLines: 2,
              color: Colors.black87,
            ),
            const SizedBox(height: 8),
            smallText(
              text: user.email,
              color: Colors.grey.shade700,
            ),
          ],
        ),
      ),
    );
  }
}
