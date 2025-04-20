import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_testovoe_tredo/presentations/widgets/users_widget/users_build_appbar.dart';
import 'package:flutter_testovoe_tredo/presentations/widgets/users_widget/users_tab_body.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/users/users_bloc.dart';

@RoutePage()
class UsersListPage extends StatefulWidget {
  const UsersListPage({super.key});

  @override
  State<UsersListPage> createState() => _UsersListPageState();
}

class _UsersListPageState extends State<UsersListPage> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

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
          appBar: UsersAppBar(
            tabController: _tabController,
            currentUser: authState.user,
          ),
          body: UsersTabBody(
            tabController: _tabController,
            currentUser: authState.user,
          ),
        );
      },
    );
  }
}
