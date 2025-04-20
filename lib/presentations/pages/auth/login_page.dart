import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_testovoe_tredo/presentations/widgets/login_widgets/_build_logo.dart';
import 'package:flutter_testovoe_tredo/presentations/widgets/login_widgets/_build_sign_in_button.dart';
import 'package:flutter_testovoe_tredo/presentations/widgets/login_widgets/_build_welcome_text.dart';
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
                  buildLogo(),
                  const SizedBox(height: 60),
                  buildWelcomeText(),
                  const SizedBox(height: 60),
                  buildSignInButton(context, state),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
