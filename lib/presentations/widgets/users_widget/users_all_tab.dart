import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/user.dart';
import '../../blocs/users/users_bloc.dart';
import '../../widgets/user_tile.dart';
import '../../../core/routes/app_router.dart';
import 'package:auto_route/auto_route.dart';

class UsersAllTab extends StatelessWidget {
  final User currentUser;

  const UsersAllTab({super.key, required this.currentUser});

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
          final allUsers = state.users;

          return ListView.builder(
            itemCount: allUsers.length,
            itemBuilder: (context, index) {
              final user = allUsers[index];
              if (user.id != currentUser.id) {
                return UserTile(
                  user: user,
                  onTap: () => _navigateToChatScreen(context, user),
                  showLastSeen: true,
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          );
        } else {
          return const Center(child: Text('Что-то пошло не так'));
        }
      },
    );
  }
}
