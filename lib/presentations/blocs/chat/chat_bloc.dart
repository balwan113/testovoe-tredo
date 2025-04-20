import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_testovoe_tredo/domain/entities/message.dart';
import 'package:flutter_testovoe_tredo/domain/repositories/chat_repositories.dart';
import 'package:uuid/uuid.dart';


part 'chat_event.dart';
part 'chat_state.dart';
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepositories _chatRepository;
  StreamSubscription? _messagesSubscription;

  ChatBloc({required ChatRepositories chatRepository})
      : _chatRepository = chatRepository,
        super(ChatInitial()) {
    on<LoadChatMessages>(_onLoadChatMessages);
    on<SendMessage>(_onSendMessage);
    on<ChatMessagesUpdated>(_onChatMessagesUpdated);
    on<MarkMessageAsRead>(_onMarkMessageAsRead);
  }

  Future<void> _onLoadChatMessages(
    LoadChatMessages event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());
    await _messagesSubscription?.cancel();
    
    _messagesSubscription = _chatRepository
        .getChatMessages(event.currentUserId, event.otherUserId)
        .listen(
          (messages) => add(ChatMessagesUpdated(messages)),
        );
  }

  Future<void> _onSendMessage(
    SendMessage event,
    Emitter<ChatState> emit,
  ) async {
    if (event.text.trim().isEmpty) return;

    final message = Message(
      id: const Uuid().v4(),
      senderId: event.senderId,
      receiverId: event.receiverId, 
      senderName: event.senderName,
      text: event.text,
      timestamp: DateTime.now(),
      isRead: false,
    );

    final result = await _chatRepository.sendMessage(message);
    result.fold(
      (failure) => emit(ChatError(failure.message)),
      (_) => null, // Messages will be updated via stream
    );
  }

  void _onChatMessagesUpdated(
    ChatMessagesUpdated event,
    Emitter<ChatState> emit,
  ) {
    emit(ChatLoaded(event.messages));
  }

  Future<void> _onMarkMessageAsRead(
    MarkMessageAsRead event,
    Emitter<ChatState> emit,
  ) async {
    await _chatRepository.updateMessageReadStatus(event.messageId);
  }

  @override
  Future<void> close() {
    _messagesSubscription?.cancel();
    return super.close();
  }
}