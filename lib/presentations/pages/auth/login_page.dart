// lib/presentation/pages/auth/login_page.dart
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/routes/app_router.dart';
import '../../blocs/auth/auth_bloc.dart';

@RoutePage()
class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            context.router.replace(const UsersListRoute());
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  _buildLogo(),
                  const SizedBox(height: 60),
                  _buildWelcomeText(),
                  const SizedBox(height: 60),
                  _buildSignInButton(context, state),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(
          Icons.chat_bubble_outline,
          size: 60,
          color: Colors.blue.shade700,
        ),
      ),
    );
  }

  Widget _buildWelcomeText() {
    return Column(
      children: const [
        Text(
          'Welcome to Flutter Chat',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),
        Text(
          'Connect with your friends and start messaging in real-time',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildSignInButton(BuildContext context, AuthState state) {
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
            : Image.asset(
                'assets/images/google_logo.png',
                height: 24,
              ),
        label: Text(
          state is AuthLoading ? 'Signing In...' : 'Sign in with Google',
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}