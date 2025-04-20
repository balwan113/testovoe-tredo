

import 'package:dartz/dartz.dart';
import 'package:flutter_testovoe_tredo/core/errors/failures.dart';
import 'package:flutter_testovoe_tredo/data/datasources/auth_remote_data_source.dart';
import 'package:flutter_testovoe_tredo/data/models/user_model.dart';
import 'package:flutter_testovoe_tredo/domain/repositories/auth_repositories.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';

import '../../domain/entities/user.dart';
class AuthRepositoriesImpl implements AuthRepositories{
  final AuthRemoteDataSource remoteDataSource;
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthRepositoriesImpl({
    required this.remoteDataSource,
     required firebase_auth.FirebaseAuth firebaseAuth,
      required GoogleSignIn googleSignIn}) : _firebaseAuth = firebaseAuth, _googleSignIn = googleSignIn;

@override 
Future<Either<Failure,User>> signInWithGoogle() async{
try{
  final googleUser = await _googleSignIn.signIn();
  if(googleUser == null){
    return Left(AuthFailure('вход был отменен'));
  }

final googleAuth = await googleUser.authentication;
final credential = firebase_auth.GoogleAuthProvider.credential(
  accessToken: googleAuth.accessToken,
  idToken: googleAuth.idToken
);


final userCredential = await _firebaseAuth.signInWithCredential(credential);

if(userCredential.user != null){
  final user = UserModel(
    id: userCredential.user!.uid,
   name: userCredential.user!.displayName ?? '',
    email: userCredential.user!.email ?? '',
     photoUrl: userCredential.user!.photoURL ?? '',
      lastActive: DateTime.now(),
       isOnline: true
       );

        await remoteDataSource.saveUserData(user);
         return Right(user);
      }else{
             return Left(AuthFailure('ошибка при входе с google'));
         }
    }catch(e){
    return Left(AuthFailure(e.toString()));
    }
}
  



  @override 
  Future<Either<Failure,void>> signOut() async{
    try{
      final user = _firebaseAuth.currentUser;
      if(user != null){
        await remoteDataSource.updateUserOnlineStatus(user.uid, false);
      }
      await _googleSignIn.signOut();
      await _firebaseAuth.signOut();
      return const Right(null);
    }catch(e){
      return Left(AuthFailure(e.toString()));
    }
  }

  @override   
  Future<Either<Failure,User?>> getCurrentUser()async{
    try{
      final firebaseUser = _firebaseAuth.currentUser;
    if(firebaseUser !=null){
      return const Right(null);
    }

    final userModel = await remoteDataSource.getUserById(firebaseUser!.uid);
    return Right(userModel);
  }catch(e){
    return Left(AuthFailure(e.toString()));
  }
}


@override   
Stream<User?> get userStream{
  return _firebaseAuth.authStateChanges().asyncMap(( firebaseUser ) async{
    if(firebaseUser == null) return null;
    try{
        final userModel = await remoteDataSource.getUserById(firebaseUser.uid);
        return userModel;
      }catch(_){
        return null;
      }
  });
}
}