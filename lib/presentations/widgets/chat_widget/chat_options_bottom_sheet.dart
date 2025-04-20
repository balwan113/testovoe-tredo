import 'package:flutter/material.dart';

class ChatOptionsBottomSheet extends StatelessWidget {
  const ChatOptionsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.delete),
            title: const Text('Очистить историю чата'),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Скоро появится функция очистки истории чата')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.block),
            title: const Text('Заблокировать пользователя'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Посмотреть профиль'),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
