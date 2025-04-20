import 'package:dartz/dartz.dart';
import 'package:flutter_testovoe_tredo/core/errors/failures.dart';
import 'package:flutter_testovoe_tredo/data/datasources/chat_remote_data_source.dart';
import 'package:flutter_testovoe_tredo/data/models/message_model.dart';
import 'package:flutter_testovoe_tredo/domain/entities/message.dart';
import 'package:flutter_testovoe_tredo/domain/entities/user.dart';
import 'package:flutter_testovoe_tredo/domain/repositories/chat_repositories.dart';

class ChatRepositoryImpl implements ChatRepositories {
  final ChatRemoteDataSource remoteDataSource;
  
  ChatRepositoryImpl({required this.remoteDataSource});

  @override
  Stream<List<User>> getAllUsers() {
    return remoteDataSource.getAllUsers();
  }

  @override
  Stream<List<Message>> getChatMessages(String userId, String otherUserId) {
    return remoteDataSource.getChatMessages(userId, otherUserId);
  }

  @override
  Future<Either<Failure, void>> sendMessage(Message message) async {
    try {
      final messageModel = MessageModel(
        id: message.id,
        senderId: message.senderId,
        receiverId: message.receiverId,
        senderName: message.senderName,
        text: message.text,
        timestamp: message.timestamp,
        isRead: message.isRead,
      );
      
      await remoteDataSource.sendMessage(messageModel);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<List<User>> getUserChats(String userId) {
    return remoteDataSource.getUserChats(userId);
  }

  @override
  Future<Either<Failure, void>> updateMessageReadStatus(String messageId) async {
    try {
      await remoteDataSource.updateMessageReadStatus(messageId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}