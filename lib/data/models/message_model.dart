import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_testovoe_tredo/domain/entities/message.dart';

class MessageModel extends Message {
  MessageModel({
    required String id,
    required String senderId,
    required String receiverId,
    required String senderName,
    required String text,
    required DateTime timestamp,
    required bool isRead,
  }) : super(
          id: id,
          senderId: senderId,
          receiverId: receiverId,
          senderName: senderName,
          text: text,
          timestamp: timestamp,
          isRead: isRead,
        );

  factory MessageModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MessageModel(
      id: doc.id,
      senderId: data['senderId'] ?? '',
      receiverId: data['receiverId'] ?? '',
      senderName: data['senderName'] ?? '',
      text: data['text'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      isRead: data['isRead'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'senderName': senderName,
      'text': text,
      'timestamp': Timestamp.fromDate(timestamp),
      'isRead': isRead,
    };
  }

  MessageModel copyWith({
    String? id,
    String? senderId,
    String? receiverId,
    String? senderName,
    String? text,
    DateTime? timestamp,
    bool? isRead,
  }) {
    return MessageModel(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      senderName: senderName ?? this.senderName,
      text: text ?? this.text,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
    );
  }
}