import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_testovoe_tredo/core/routes/app_router.dart';
import 'package:flutter_testovoe_tredo/presentations/widgets/user_tile.dart';
import '../../../domain/entities/user.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/users/users_bloc.dart';

@RoutePage()
class UsersListPage extends StatefulWidget {
  const UsersListPage({Key? key}) : super(key: key);

  @override
  State<UsersListPage> createState() => _UsersListPageState();
}

class _UsersListPageState extends State<UsersListPage> with TickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    // Load users when page is initialized
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      context.read<UsersBloc>().add(LoadAllUsers(authState.user));
      context.read<UsersBloc>().add(LoadUserChats(authState.user.id));
    }
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        if (authState is! AuthAuthenticated) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        
        return Scaffold(
          appBar: _buildAppBar(authState.user),
          body: _buildBody(authState.user),
        );
      },
    );
  }
  
  PreferredSizeWidget _buildAppBar(User currentUser) {
    return AppBar(
      title: const Text('Flutter Chat'),
      actions: [
        IconButton(
          icon: const Icon(Icons.exit_to_app),
          onPressed: () {
            context.read<AuthBloc>().add(SignOut());
          },
        ),
      ],
      bottom: TabBar(
        controller: _tabController,
        tabs: const [
          Tab(text: 'Chats'),
          Tab(text: 'All Users'),
        ],
      ),
    );
  }
  
  Widget _buildBody(User currentUser) {
    return TabBarView(
      controller: _tabController,
      children: [
        // Chats tab
        BlocBuilder<UsersBloc, UsersState>(
          builder: (context, state) {
            if (state is UsersLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is UsersLoaded) {
              final chatUsers = state.chatUsers;
              
              if (chatUsers.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.chat_bubble_outline,
                        size: 80,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'No chats yet',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Start a conversation with someone',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
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
                    onTap: () => _navigateToChatScreen(currentUser, user),
                    showLastSeen: true,
                  );
                },
              );
            } else {
              return const Center(child: Text('Something went wrong'));
            }
          },
        ),
        
        // All users tab
        BlocBuilder<UsersBloc, UsersState>(
          builder: (context, state) {
            if (state is UsersLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is UsersLoaded) {
              final allUsers = state.users;
              
              if (allUsers.isEmpty) {
                return const Center(child: Text('No users found'));
              }
              
              return ListView.builder(
                itemCount: allUsers.length,
                itemBuilder: (context, index) {
                  final user = allUsers[index];
                  if (user.id != currentUser.id) {
                    return UserTile(
                      user: user,
                      onTap: () => _navigateToChatScreen(currentUser, user),
                      showLastSeen: true,
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              );
            } else {
              return const Center(child: Text('Something went wrong'));
            }
          },
        ),
      ],
    );
  }
  
  void _navigateToChatScreen(User currentUser, User otherUser) {
    context.router.push(
      ChatRoute(currentUser: currentUser, otherUser: otherUser),
    );
  }
}
