import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_testovoe_tredo/domain/entities/user.dart';
import 'package:flutter_testovoe_tredo/presentations/pages/auth/login_page.dart';
import 'package:flutter_testovoe_tredo/presentations/pages/chat/chat_page.dart';
import 'package:flutter_testovoe_tredo/presentations/pages/users/users_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends  RootStackRouter {
  @override
  List<AutoRoute> get routes => [
      
      ];
}
