part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class LoadChatMessages extends ChatEvent {
  final String currentUserId;
  final String otherUserId;

  const LoadChatMessages({
    required this.currentUserId,
    required this.otherUserId,
  });

  @override
  List<Object> get props => [currentUserId, otherUserId];
}

class SendMessage extends ChatEvent {
  final String senderId;
  final String receiverId;
  final String senderName;
  final String text;

  const SendMessage({
    required this.senderId,
    required this.receiverId,
    required this.senderName,
    required this.text,
  });

  @override
  List<Object> get props => [senderId, receiverId, senderName, text];
}

class ChatMessagesUpdated extends ChatEvent {
  final List<Message> messages;

  const ChatMessagesUpdated(this.messages);

  @override
  List<Object> get props => [messages];
}

class MarkMessageAsRead extends ChatEvent {
  final String messageId;

  const MarkMessageAsRead(this.messageId);

  @override
  List<Object> get props => [messageId];
}
