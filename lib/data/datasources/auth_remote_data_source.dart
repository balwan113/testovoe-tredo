

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_testovoe_tredo/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<void> saveUserData(UserModel user);
  Future<UserModel> getUserById(String userid);
  Future<void> updateUserOnlineStatus (String userId, bool isOnline);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource{
  final FirebaseFirestore _firestore;
  
AuthRemoteDataSourceImpl({required FirebaseFirestore firestore}) : _firestore = firestore;


@override 
Future<void> saveUserData(UserModel user) async{
  await _firestore.collection('users').doc(user.id).set(
    user.toMap(),
    SetOptions(merge: true),
  );
}


@override 
Future<void> updateUserOnlineStatus(String userid, bool isOnline) async{
  await _firestore.collection('users').doc(userid).update({
    'isOnline':isOnline,
    'lastActive':Timestamp.now(),
  });
  
}

  @override
  Future<UserModel> getUserById(String userid)async  {
final docsnapshot = await _firestore.collection('users').doc(userid).get();
if(docsnapshot.exists){
  return UserModel.fromFireStore(docsnapshot);
}else{
  throw Exception('пользователь не найден');
}
  }
}