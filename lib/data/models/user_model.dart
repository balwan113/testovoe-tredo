


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_testovoe_tredo/domain/entities/user.dart';

class UserModel extends User{
  UserModel({
    required String id,
    required String name,
    required String email,
    required String photoUrl,
    required DateTime lastActive,
    required bool isOnline,
  }): super(
    id: id,
    name: name,
    email: email,
    photoUrl: photoUrl,
    lastActive: lastActive,
    isOnline: isOnline
    );
    

factory UserModel.fromFireStore(DocumentSnapshot doc){
  final data = doc.data() as Map<String,dynamic>;
  return UserModel(
    id:doc.id, 
    name: data['name'] ?? '',
    email: data['email'] ?? '',
    photoUrl: data['photoUrl'] ?? '',
    lastActive: (data['lastActive'] as Timestamp).toDate(),
    isOnline: data['isOnline']?? false,
  );
}
Map<String, dynamic> toMap() {
  return {
    'name': name,
    'email': email,
    'photoUrl': photoUrl,
    'lastActive': lastActive,
    'isOnline': isOnline,
  };
}

UserModel copyWith({
  String? id,
  String? name,
  String? email,
  String? photoUrl,
  DateTime? lastActive,
  bool? isOnline,
}){
  return UserModel(
    id:  id ?? this.id,
     name: name ?? this.name,
      email: email ?? this.email,
       photoUrl: photoUrl ?? this.photoUrl,
       lastActive: lastActive ?? this.lastActive, 
       isOnline: isOnline ?? this.isOnline
       );
}
}