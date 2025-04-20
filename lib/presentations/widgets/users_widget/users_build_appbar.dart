import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import '../../../core/routes/app_router.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../../domain/entities/user.dart';

class UsersAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TabController tabController;
  final User currentUser;

  const UsersAppBar({
    super.key,
    required this.tabController,
    required this.currentUser,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + kTextTabBarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Чат'),
      actions: [
        IconButton(
          icon: const Icon(Icons.exit_to_app),
          onPressed: () {
            context.read<AuthBloc>().add(SignOut());
            context.router.replace(const LoginRoute());
          },
        ),
      ],
      bottom: TabBar(
        controller: tabController,
        tabs: const [
          Tab(text: 'Чаты'),
          Tab(text: 'Все Пользователи'),
        ],
      ),
    );
  }
}
