import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_testovoe_tredo/domain/repositories/chat_repositories.dart';
import '../../../domain/entities/user.dart';

part 'users_event.dart';
part 'users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final ChatRepositories _chatRepository;
  StreamSubscription? _usersSubscription;
  StreamSubscription? _chatsSubscription;

  UsersBloc({required ChatRepositories chatRepository})
      : _chatRepository = chatRepository,
        super(UsersInitial()) {
    on<LoadAllUsers>(_onLoadAllUsers);
    on<LoadUserChats>(_onLoadUserChats);
    on<UsersUpdated>(_onUsersUpdated);
    on<UserChatsUpdated>(_onUserChatsUpdated);
  }

  Future<void> _onLoadAllUsers(
    LoadAllUsers event,
    Emitter<UsersState> emit,
  ) async {
    emit(UsersLoading());
    await _usersSubscription?.cancel();
    
    _usersSubscription = _chatRepository
    .getAllUsers()
    .listen((users) {
      final userList = users.cast<User>(); 
      add(UsersUpdated(userList));
    });

  }

  Future<void> _onLoadUserChats(
    LoadUserChats event,
    Emitter<UsersState> emit,
  ) async {
    emit(UsersLoading());
    await _chatsSubscription?.cancel();
    
    _chatsSubscription = _chatRepository
    .getUserChats(event.userId)
    .listen((users) {
      final userList = users.cast<User>(); 
      add(UserChatsUpdated(userList));
    });

  }

  void _onUsersUpdated(
    UsersUpdated event,
    Emitter<UsersState> emit,
  ) {
    final currentUser = (state is UsersLoaded) 
        ? (state as UsersLoaded).currentUser
        : null;
        
    final filteredUsers = event.users
        .where((user) => user.id != currentUser?.id)
        .toList();
        
    emit(UsersLoaded(
      users: filteredUsers,
      chatUsers: (state is UsersLoaded) ? (state as UsersLoaded).chatUsers : [],
      currentUser: currentUser,
    ));
  }

  void _onUserChatsUpdated(
    UserChatsUpdated event,
    Emitter<UsersState> emit,
  ) {
    final allUsers = (state is UsersLoaded) 
        ? (state as UsersLoaded).users
        : <User>[];
        
    final currentUser = (state is UsersLoaded) 
        ? (state as UsersLoaded).currentUser
        : null;
        
    emit(UsersLoaded(
      users: allUsers,
      chatUsers: event.users,
      currentUser: currentUser,
    ));
  }

  @override
  Future<void> close() {
    _usersSubscription?.cancel();
    _chatsSubscription?.cancel();
    return super.close();
  }
}