part of 'users_bloc.dart';

abstract class UsersState extends Equatable {
  const UsersState();
  
  @override
  List<Object?> get props => [];
}

class UsersInitial extends UsersState {}

class UsersLoading extends UsersState {}

class UsersLoaded extends UsersState {
  final List<User> users;
  final List<User> chatUsers;
  final User? currentUser;

  const UsersLoaded({
    required this.users,
    required this.chatUsers,
    this.currentUser,
  });

  @override
  List<Object?> get props => [users, chatUsers, currentUser];
}

class UsersError extends UsersState {
  final String message;

  const UsersError(this.message);

  @override
  List<Object> get props => [message];
}