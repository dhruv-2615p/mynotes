import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  Timer? _timer;

  @override
  void initState() {
    _startEmailVerificationCheck();
    super.initState();
  }

  void _startEmailVerificationCheck() {
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      context.read<AuthBloc>().add(const AuthEventInitialize());
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthStateLoggedIn && state.user.isEmailVerified) {
          _timer?.cancel();
          context.read<AuthBloc>().add(
                const AuthEventLogOut(),
              );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Email verification"),
          backgroundColor: Colors.blue,
        ),
        body: Center(
          child: Column(
            children: [
              const Text(
                  "Email already sended to verify.\nPlease check you mail."),
              const Text("If you did not get mail, press this button."),
              TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(
                        const AuthEventSendEmailVerification(),
                      );
                },
                child: const Text("Send email again"),
              ),
              TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(
                        const AuthEventLogOut(),
                      );
                },
                child: const Text('Restart'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
