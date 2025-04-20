import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../domain/entities/user.dart';

class UserTile extends StatelessWidget {
  final User user;
  final VoidCallback onTap;
  final bool showLastSeen;

  const UserTile({
    Key? key,
    required this.user,
    required this.onTap,
    this.showLastSeen = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: CircleAvatar(
        radius: 24,
        backgroundColor: Colors.grey.shade200,
        backgroundImage: user.photoUrl.isNotEmpty
            ? NetworkImage(user.photoUrl)
            : null,
        child: user.photoUrl.isEmpty
            ? Text(
                user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                style: const TextStyle(fontSize: 20),
              )
            : null,
      ),
      title: Text(
        user.name,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      subtitle: showLastSeen
          ? Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: user.isOnline ? Colors.green : Colors.grey,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  user.isOnline
                      ? 'Online'
                      : 'Last seen ${_formatLastSeen(user.lastActive)}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 13,
                  ),
                ),
              ],
            )
          : null,
      onTap: onTap,
    );
  }

  String _formatLastSeen(DateTime lastActive) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final lastActiveDate = DateTime(
      lastActive.year,
      lastActive.month,
      lastActive.day,
    );

    if (lastActiveDate == today) {
      return 'today at ${DateFormat.Hm().format(lastActive)}';
    } else if (lastActiveDate == yesterday) {
      return 'yesterday at ${DateFormat.Hm().format(lastActive)}';
    } else {
      return DateFormat.yMMMd().format(lastActive);
    }
  }
}