import 'package:flutter/material.dart';
import 'package:flutter_testovoe_tredo/presentations/widgets/users_widget/users_all_tab.dart';
import 'package:flutter_testovoe_tredo/presentations/widgets/users_widget/users_chats_tab.dart';
import '../../../domain/entities/user.dart';

class UsersTabBody extends StatelessWidget {
  final TabController tabController;
  final User currentUser;

  const UsersTabBody({
    super.key,
    required this.tabController,
    required this.currentUser,
  });

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: tabController,
      children: [
        UsersChatsTab(currentUser: currentUser),
        UsersAllTab(currentUser: currentUser),
      ],
    );
  }
}
