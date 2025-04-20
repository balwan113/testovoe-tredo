import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_testovoe_tredo/presentations/blocs/auth/auth_bloc.dart';
Widget buildSignInButton(BuildContext context, AuthState state) {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton.icon(
      onPressed: state is AuthLoading
          ? null
          : () => context.read<AuthBloc>().add(SignInWithGoogle()),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      icon: state is AuthLoading
          ? Container(
              width: 24,
              height: 24,
              padding: const EdgeInsets.all(2.0),
              child: const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3,
              ),
            )
          : Text("Google"),
      label: Text(
        state is AuthLoading ? 'Войти' : 'Войти с помощью Google',
        style: const TextStyle(fontSize: 16),
      ),
    ),
  );
}
