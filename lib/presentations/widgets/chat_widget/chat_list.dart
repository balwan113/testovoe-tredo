import 'package:flutter/material.dart';
import 'package:flutter_testovoe_tredo/domain/entities/message.dart';
import 'package:flutter_testovoe_tredo/domain/entities/user.dart';
import 'package:flutter_testovoe_tredo/presentations/widgets/chat_widget/chat_bubble.dart';

class ChatList extends StatelessWidget {
  final List<Message> messages;
  final User currentUser;
  final User otherUser;
  final ScrollController scrollController;

  const ChatList({
    super.key,
    required this.messages,
    required this.currentUser,
    required this.otherUser,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        final isCurrentUser = message.senderId == currentUser.id;
        final showDateHeader = index == 0 || !_isSameDay(
          messages[index].timestamp,
          messages[index - 1].timestamp,
        );

        return Column(
          children: [
            if (showDateHeader) _buildDateHeader(message.timestamp),
            ChatBubble(
              message: message,
              isCurrentUser: isCurrentUser,
              senderName: isCurrentUser ? currentUser.name : otherUser.name,
              text: message.text,
              timestamp: message.timestamp,
            ),
          ],
        );
      },
    );
  }

  Widget _buildDateHeader(DateTime timestamp) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDate = DateTime(timestamp.year, timestamp.month, timestamp.day);

    String dateLabel;
    if (messageDate == today) {
      dateLabel = 'Сегодня';
    } else if (messageDate == yesterday) {
      dateLabel = 'Вчера';
    } else {
      dateLabel = '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(dateLabel, style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
        ),
      ),
    );
  }

  bool _isSameDay(DateTime d1, DateTime d2) {
    return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
  }
}
