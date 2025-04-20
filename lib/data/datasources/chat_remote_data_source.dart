


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_testovoe_tredo/data/models/message_model.dart';
import 'package:flutter_testovoe_tredo/data/models/user_model.dart';

abstract class ChatRemoteDataSource {
  Stream<List<UserModel>> getAllUsers();
  Stream<List<MessageModel>> getChatMessages(String userid, String otherUserId);
  Future<void> sendMessage(MessageModel message);
  Stream<List<UserModel>> getUserChats(String userId);
  Future<void> updateMessageReadStatus(String messageId);
}


class ChatRemoteDataSourceImpl implements ChatRemoteDataSource{
  final FirebaseFirestore _firestore;

  ChatRemoteDataSourceImpl({required  FirebaseFirestore firestore}) : _firestore = firestore;
  
  @override     
  Stream<List<UserModel>> getAllUsers(){
    return _firestore
              .collection('users')
              .snapshots()
              .map((snapshot) => snapshot.docs
              .map((doc) => UserModel.fromFireStore(doc)
              ).toList()
        );
  }


  @override   
  Stream<List<MessageModel>> getChatMessages(String userId, String otherUserId){
    final chatId = userId.compareTo(otherUserId) < 0
    ? '$userId-$otherUserId' 
    : '$otherUserId-$userId';

    return _firestore
    .collection('chats')
    .doc(chatId)
    .collection('messages')
    .orderBy('timestamp',descending: false)
    .snapshots()
    .map((snapshot) => snapshot.docs
    .map((doc) => MessageModel.fromFirestore(doc)).toList()
    );
  }


  @override 
Future<void> sendMessage(MessageModel message) async{
  final chatId = message.senderId.compareTo(message.receiverId) < 0
  ? '${message.senderId}-${message.receiverId}'
  : '${message.receiverId}-${message.senderId}';


  await _firestore
  .collection('chats')
  .doc(chatId)
  .collection('messages')
  .doc(message.id)
  .set(message.toMap());

   
  await _firestore
  .collection('users')
  .doc(message.senderId)
  .collection('chats')
  .doc(message.receiverId)
  .set({
  'lastMessage':message.text,
  'timestamp':Timestamp.fromDate(message.timestamp),
  'unredcount':0,
  },SetOptions(merge: true));


  final recipientChatDoc = await _firestore
  .collection('users')
  .doc(message.receiverId)
  .collection('chats')
  .doc(message.senderId)
  .get();

  int unreadCount = 0;
  if(recipientChatDoc.exists){
    final data = recipientChatDoc.data();
    unreadCount = (data?['unread'] ?? 0) as int;

  }


  await _firestore
  .collection('users')
  .doc(message.receiverId)
  .collection('chats')
  .doc(message.senderId)
  .set({
    'lastMessage':message.text,
    'timestamp':Timestamp.fromDate(message.timestamp),
    'unreadCount': unreadCount + 1,
  },SetOptions(merge: true));
}


@override 
Stream<List<UserModel>> getUserChats(String userId){
  return _firestore
  .collection('users')
  .doc(userId)
  .collection('chats')
  .orderBy('timestamp',descending: true)
  .snapshots()
  .asyncMap((chatSnapshot) async{
    List<UserModel> users = [];
    for(var doc in chatSnapshot.docs){
      final chatUserId = doc.id;
      try{
final userDoc = await _firestore.collection('users').doc(chatUserId).get();
if(userDoc.exists){
  final user = UserModel.fromFireStore(userDoc);
  users.add(user);
}
      }catch(e){
print('ошибка при обработке user $chatUserId: $e');
       }
      }
      return users;
    }
  );
}


@override 
Future<void> updateMessageReadStatus(String messageId) async{
  final messagesQuery = await _firestore
  .collectionGroup('messages')
  .where(FieldPath.documentId,isEqualTo: messageId)
  .get();

  if(messagesQuery.docs.isNotEmpty){
    final messageDoc = messagesQuery.docs.first;
    final chatPath = messageDoc.reference.parent.parent!.path;
    
    await _firestore
    .doc('$chatPath/messages/$messageId')
    .update({'isRead' : true});
  }
}
}