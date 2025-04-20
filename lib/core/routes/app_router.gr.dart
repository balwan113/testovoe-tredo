// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [ChatPage]
class ChatRoute extends PageRouteInfo<ChatRouteArgs> {
  ChatRoute({
    Key? key,
    required User currentUser,
    required User otherUser,
    List<PageRouteInfo>? children,
  }) : super(
         ChatRoute.name,
         args: ChatRouteArgs(
           key: key,
           currentUser: currentUser,
           otherUser: otherUser,
         ),
         initialChildren: children,
       );

  static const String name = 'ChatRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ChatRouteArgs>();
      return ChatPage(
        key: args.key,
        currentUser: args.currentUser,
        otherUser: args.otherUser,
      );
    },
  );
}

class ChatRouteArgs {
  const ChatRouteArgs({
    this.key,
    required this.currentUser,
    required this.otherUser,
  });

  final Key? key;

  final User currentUser;

  final User otherUser;

  @override
  String toString() {
    return 'ChatRouteArgs{key: $key, currentUser: $currentUser, otherUser: $otherUser}';
  }
}

/// generated route for
/// [LoginPage]
class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute({List<PageRouteInfo>? children})
    : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const LoginPage();
    },
  );
}

/// generated route for
/// [UsersListPage]
class UsersListRoute extends PageRouteInfo<void> {
  const UsersListRoute({List<PageRouteInfo>? children})
    : super(UsersListRoute.name, initialChildren: children);

  static const String name = 'UsersListRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const UsersListPage();
    },
  );
}
