import 'package:flutter/material.dart';
import 'package:flutter_testovoe_tredo/domain/entities/user.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_testovoe_tredo/presentations/widgets/chat_widget/chat_options_bottom_sheet.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final User currentUser;
  final User otherUser;

  const ChatAppBar({
    super.key,
    required this.currentUser,
    required this.otherUser,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => context.router.pop(),
      ),
      title: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.grey.shade200,
            backgroundImage: otherUser.photoUrl.isNotEmpty
                ? NetworkImage(otherUser.photoUrl)
                : null,
            child: otherUser.photoUrl.isEmpty
                ? Text(
                    otherUser.name.isNotEmpty ? otherUser.name[0].toUpperCase() : '?',
                    style: const TextStyle(fontSize: 16),
                  )
                : null,
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(otherUser.name, style: const TextStyle(fontSize: 16)),
              Text(
                otherUser.isOnline ? 'В сети' : 'Не в сети',
                style: TextStyle(
                  fontSize: 12,
                  color: otherUser.isOnline ? Colors.green : Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (context) => ChatOptionsBottomSheet(),
            );
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
