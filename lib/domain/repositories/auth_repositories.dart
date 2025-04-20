

import 'package:dartz/dartz.dart';
import 'package:flutter_testovoe_tredo/core/errors/failures.dart';
import 'package:flutter_testovoe_tredo/domain/entities/user.dart';

abstract class AuthRepositories {
  Future<Either<Failure,User>> signInWithGoogle();
  Future<Either<Failure,void>> signOut();
  Future<Either<Failure,User?>> getCurrentUser();
  Stream<User?> get userStream;
}