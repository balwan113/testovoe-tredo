import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/user.dart';
import '../../blocs/users/users_bloc.dart';
import '../../widgets/user_tile.dart';
import '../../../core/routes/app_router.dart';
import 'package:auto_route/auto_route.dart';

class UsersChatsTab extends StatelessWidget {
  final User currentUser;

  const UsersChatsTab({super.key, required this.currentUser});

  void _navigateToChatScreen(BuildContext context, User otherUser) {
    context.router.push(ChatRoute(currentUser: currentUser, otherUser: otherUser));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UsersBloc, UsersState>(
      builder: (context, state) {
        if (state is UsersLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is UsersLoaded) {
          final chatUsers = state.chatUsers;

          if (chatUsers.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.chat_bubble_outline, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Чатов пока нет', style: TextStyle(fontSize: 18, color: Colors.grey)),
                  SizedBox(height: 8),
                  Text('Начать разговор с кем-то', style: TextStyle(fontSize: 14, color: Colors.grey)),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: chatUsers.length,
            itemBuilder: (context, index) {
              final user = chatUsers[index];
              return UserTile(
                user: user,
                onTap: () => _navigateToChatScreen(context, user),
                showLastSeen: true,
              );
            },
          );
        } else {
          return const Center(child: Text('Что-то пошло не так'));
        }
      },
    );
  }
}
