import 'package:dartz/dartz.dart';
import 'package:flutter_testovoe_tredo/core/errors/failures.dart';
import 'package:flutter_testovoe_tredo/domain/entities/message.dart';
import 'package:flutter_testovoe_tredo/domain/entities/user.dart';

abstract class ChatRepositories {
  Stream<List<User>> getAllUsers();
  Stream<List<Message>> getChatMessages(String userId, String otherUserId);
  Future<Either<Failure,void>> sendMessage(Message message);
  Stream<List<User>> getUserChats (String userId);
  Future<Either<Failure,void>> updateMessageReadStatus(String messageId);
}