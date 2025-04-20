import 'package:flutter/material.dart';
import 'package:flutter_testovoe_tredo/core/routes/app_router.dart';
import 'package:flutter_testovoe_tredo/data/datasources/auth_remote_data_source.dart';
import 'package:flutter_testovoe_tredo/data/datasources/chat_remote_data_source.dart';
import 'package:flutter_testovoe_tredo/data/repositories/auth_repositories_impl.dart';
import 'package:flutter_testovoe_tredo/data/repositories/chat_repositories.dart';
import 'package:flutter_testovoe_tredo/domain/repositories/auth_repositories.dart';
import 'package:flutter_testovoe_tredo/domain/repositories/chat_repositories.dart';
import 'package:flutter_testovoe_tredo/presentations/blocs/auth/auth_bloc.dart';
import 'package:flutter_testovoe_tredo/presentations/blocs/chat/chat_bloc.dart';
import 'package:flutter_testovoe_tredo/presentations/blocs/users/users_bloc.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class MyApp extends StatelessWidget {
  MyApp({super.key});
  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FirebaseFirestore>(
          create: (_) => FirebaseFirestore.instance,
        ),
        Provider<ChatRemoteDataSource>(
          create: (context) => ChatRemoteDataSourceImpl(
            firestore: context.read<FirebaseFirestore>(),
          ),
        ),
        Provider<ChatRepositories>(
          create: (context) => ChatRepositoryImpl(
            remoteDataSource: context.read<ChatRemoteDataSource>(),
          ),
        ),
        BlocProvider<ChatBloc>(
          create: (context) => ChatBloc(
            chatRepository: context.read<ChatRepositories>(),
          ),
        ),
        BlocProvider<UsersBloc>(
          create: (context) => UsersBloc(
            chatRepository: context.read<ChatRepositories>(),
          ),
        ),
        Provider<FirebaseAuth>(
          create: (_) => FirebaseAuth.instance,
        ),
        Provider<GoogleSignIn>(
          create: (_) => GoogleSignIn(),
        ),
        Provider<AuthRemoteDataSourceImpl>(
          create: (context) => AuthRemoteDataSourceImpl(
            firestore: context.read<FirebaseFirestore>(),
          ),
        ),
        Provider<AuthRepositories>(
          create: (context) => AuthRepositoriesImpl(
            remoteDataSource: context.read<AuthRemoteDataSourceImpl>(),
            firebaseAuth: context.read<FirebaseAuth>(),
            googleSignIn: context.read<GoogleSignIn>(),
          ),
        ),
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(
            authRepository: context.read<AuthRepositories>(),
          ),
        ),
      ],
      child: MaterialApp.router(
        routerConfig: _appRouter.config(),
      ),
    );
  }
}