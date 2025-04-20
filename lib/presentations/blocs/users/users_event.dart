part of 'users_bloc.dart';

abstract class UsersEvent extends Equatable {
  const UsersEvent();

  @override
  List<Object> get props => [];
}

class LoadAllUsers extends UsersEvent {
  final User currentUser;

  const LoadAllUsers(this.currentUser);

  @override
  List<Object> get props => [currentUser];
}

class LoadUserChats extends UsersEvent {
  final String userId;

  const LoadUserChats(this.userId);

  @override
  List<Object> get props => [userId];
}

class UsersUpdated extends UsersEvent {
  final List<User> users;

  const UsersUpdated(this.users);

  @override
  List<Object> get props => [users];
}

class UserChatsUpdated extends UsersEvent {
  final List<User> users;

  const UserChatsUpdated(this.users);

  @override
  List<Object> get props => [users];
}