import 'package:flutter/material.dart';
import 'package:riverpod_base/core/services/text-service/text-service.dart';

import '../../domain/entities/user_entity.dart';

class UserCard extends StatelessWidget {
  const UserCard({super.key, required this.user, required this.onTap});

  final UserEntity user;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.5,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              headingText(
                text: user.name,
                maxLines: 2,
                color: Colors.black87,
              ),
              const SizedBox(height: 8),
              normalText(
                text: '@${user.username}',
                color: Colors.black54,
              ),
              const SizedBox(height: 8),
              smallText(
                text: user.email,
                color: Colors.grey.shade700,
              ),
              const SizedBox(height: 12),
              smallText(
                text: '${user.address.city} • ${user.company.name}',
                color: Colors.grey.shade600,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
