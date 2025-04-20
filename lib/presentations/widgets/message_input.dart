import 'package:flutter/material.dart';

class MessageInput extends StatefulWidget {
  final Function(String) onSend;

  const MessageInput({
    Key? key,
    required this.onSend,
  }) : super(key: key);

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final TextEditingController _controller = TextEditingController();
  bool _isComposing = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      widget.onSend(text);
      _controller.clear();
      setState(() {
        _isComposing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -2),
            blurRadius: 4,
            color: Colors.black.withOpacity(0.1),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.attach_file),
            onPressed: () {
              // TODO: Implement file attachment
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Attachment feature coming soon'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                hintText: 'Type a message...',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              onChanged: (text) {
                setState(() {
                  _isComposing = text.trim().isNotEmpty;
                });
              },
              onSubmitted: (_) {
                if (_isComposing) {
                  _sendMessage();
                }
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.emoji_emotions_outlined),
            onPressed: () {
              // TODO: Implement emoji picker
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Emoji picker coming soon'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            child: _isComposing
                ? IconButton(
                    icon: const Icon(Icons.send),
                    color: Theme.of(context).primaryColor,
                    onPressed: _sendMessage,
                  )
                : IconButton(
                    icon: const Icon(Icons.mic),
                    onPressed: () {
                      // TODO: Implement voice message
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Voice message feature coming soon'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}