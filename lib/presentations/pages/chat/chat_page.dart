import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_testovoe_tredo/domain/entities/user.dart';
import 'package:flutter_testovoe_tredo/presentations/blocs/chat/chat_bloc.dart';
import 'package:flutter_testovoe_tredo/presentations/widgets/chat_widget/chat_app_bar.dart';
import 'package:flutter_testovoe_tredo/presentations/widgets/chat_widget/chat_list.dart';
import 'package:flutter_testovoe_tredo/presentations/widgets/chat_widget/empty_chat.dart';
import 'package:flutter_testovoe_tredo/presentations/widgets/chat_widget/message_input_field.dart';

@RoutePage()
class ChatPage extends StatefulWidget {
  final User currentUser;
  final User otherUser;

  const ChatPage({super.key, required this.currentUser, required this.otherUser});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(
          LoadChatMessages(
            currentUserId: widget.currentUser.id,
            otherUserId: widget.otherUser.id,
          ),
        );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChatAppBar(
        currentUser: widget.currentUser,
        otherUser: widget.otherUser,
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<ChatBloc, ChatState>(
              listener: (context, state) {
                if (state is ChatLoaded) {
                  for (final message in state.messages) {
                    if (message.receiverId == widget.currentUser.id && !message.isRead) {
                      context.read<ChatBloc>().add(MarkMessageAsRead(message.id));
                    }
                  }

                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _scrollToBottom();
                  });
                }
              },
              builder: (context, state) {
                if (state is ChatLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ChatLoaded) {
                  return state.messages.isEmpty
                      ? const EmptyChat()
                      : ChatList(
                          messages: state.messages,
                          currentUser: widget.currentUser,
                          otherUser: widget.otherUser,
                          scrollController: _scrollController,
                        );
                } else if (state is ChatError) {
                  return Center(child: Text(state.message));
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          MessageInputField(
            currentUser: widget.currentUser,
            otherUser: widget.otherUser,
          ),
        ],
      ),
    );
  }
}
