// lib/presentation/pages/chat/chat_page.dart
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_testovoe_tredo/presentations/widgets/chat_bubble.dart';
import 'package:flutter_testovoe_tredo/presentations/widgets/message_input.dart';
import '../../../domain/entities/message.dart';
import '../../../domain/entities/user.dart';
import '../../blocs/chat/chat_bloc.dart';

@RoutePage()
class ChatPage extends StatefulWidget {
  final User currentUser;
  final User otherUser;

  const ChatPage({
    Key? key,
    required this.currentUser,
    required this.otherUser,
  }) : super(key: key);

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
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<ChatBloc, ChatState>(
              listener: (context, state) {
                if (state is ChatLoaded) {
                  // Mark newly received messages as read
                  for (final message in state.messages) {
                    if (message.receiverId == widget.currentUser.id && !message.isRead) {
                      context.read<ChatBloc>().add(MarkMessageAsRead(message.id));
                    }
                  }
                  
                  // Scroll to bottom on new messages
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _scrollToBottom();
                  });
                }
              },
              builder: (context, state) {
                if (state is ChatLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ChatLoaded) {
                  final messages = state.messages;
                  
                  if (messages.isEmpty) {
                    return _buildEmptyChat();
                  }
                  
                  return _buildChatList(messages);
                } else if (state is ChatError) {
                  return Center(child: Text(state.message));
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
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
            backgroundImage: widget.otherUser.photoUrl.isNotEmpty
                ? NetworkImage(widget.otherUser.photoUrl)
                : null,
            child: widget.otherUser.photoUrl.isEmpty
                ? Text(
                    widget.otherUser.name.isNotEmpty
                        ? widget.otherUser.name[0].toUpperCase()
                        : '?',
                    style: const TextStyle(fontSize: 16),
                  )
                : null,
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.otherUser.name,
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                widget.otherUser.isOnline ? 'Online' : 'Offline',
                style: TextStyle(
                  fontSize: 12,
                  color: widget.otherUser.isOnline ? Colors.green : Colors.grey,
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
            // Show chat options
            showModalBottomSheet(
              context: context,
              builder: (context) => _buildChatOptions(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildChatOptions() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.delete),
            title: const Text('Clear chat history'),
            onTap: () {
              Navigator.pop(context);
              _showDeleteConfirmationDialog();
            },
          ),
          ListTile(
            leading: const Icon(Icons.block),
            title: const Text('Block user'),
            onTap: () {
              Navigator.pop(context);
              // TODO: Implement block user functionality
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('View profile'),
            onTap: () {
              Navigator.pop(context);
              // TODO: Navigate to user profile
            },
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear chat history'),
        content: const Text('Are you sure you want to delete all messages? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Просто загружаем чат заново, так как нет события для удаления
              // TODO: Добавить реализацию удаления истории чата
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Clear chat history functionality coming soon'),
                ),
              );
              // Перезагрузка сообщений
              context.read<ChatBloc>().add(
                LoadChatMessages(
                  currentUserId: widget.currentUser.id,
                  otherUserId: widget.otherUser.id,
                ),
              );
            },
            child: const Text('DELETE'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyChat() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'No messages yet',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Say hello to ${widget.otherUser.name}!',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatList(List<Message> messages) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        final bool isCurrentUser = message.senderId == widget.currentUser.id;
        
        // Add date header if needed
        final bool showDateHeader = index == 0 || 
            !_isSameDay(messages[index].timestamp, messages[index - 1].timestamp);
        
        return Column(
          children: [
            if (showDateHeader)
              _buildDateHeader(message.timestamp),
            ChatBubble(
              message: message,
              isCurrentUser: isCurrentUser,
              senderName: isCurrentUser ? widget.currentUser.name : widget.otherUser.name,
              text: message.text, // Используем text вместо content
              timestamp: message.timestamp,
            ),
          ],
        );
      },
    );
  }
  
  Widget _buildDateHeader(DateTime timestamp) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            _formatDateHeader(timestamp),
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade700,
            ),
          ),
        ),
      ),
    );
  }
  
  String _formatDateHeader(DateTime timestamp) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDate = DateTime(timestamp.year, timestamp.month, timestamp.day);
    
    if (messageDate == today) {
      return 'Today';
    } else if (messageDate == yesterday) {
      return 'Yesterday';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
  
  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && 
           date1.month == date2.month && 
           date1.day == date2.day;
  }

  Widget _buildMessageInput() {
    return MessageInput(
      onSend: (String message) {
        if (message.trim().isNotEmpty) {
          context.read<ChatBloc>().add(
                SendMessage(
                  text: message,
                  senderId: widget.currentUser.id,
                  receiverId: widget.otherUser.id,
                  senderName: widget.currentUser.name, // Добавляем имя отправителя
                ),
              );
        }
      },
    );
  }
}