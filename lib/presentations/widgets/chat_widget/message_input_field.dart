import 'package:flutter/material.dart';
import 'package:flutter_testovoe_tredo/domain/entities/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_testovoe_tredo/presentations/blocs/chat/chat_bloc.dart';
import 'package:flutter_testovoe_tredo/presentations/widgets/chat_widget/message_input.dart';

class MessageInputField extends StatelessWidget {
  final User currentUser;
  final User otherUser;

  const MessageInputField({
    super.key,
    required this.currentUser,
    required this.otherUser,
  });

  @override
  Widget build(BuildContext context) {
    return MessageInput(
      onSend: (String text) {
        if (text.trim().isNotEmpty) {
          context.read<ChatBloc>().add(
                SendMessage(
                  text: text,
                  senderId: currentUser.id,
                  receiverId: otherUser.id,
                  senderName: currentUser.name,
                ),
              );
        }
      },
    );
  }
}
