import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/utilities/show_error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(hintText: 'Email'),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(hintText: 'Password'),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                await FirebaseAuth.instance.createUserWithEmailAndPassword(
                    email: email, password: password);
                Navigator.of(context).pushNamedAndRemoveUntil(
                  loginRoute,
                  (route) => false,
                );
              } on FirebaseAuthException catch (e) {
                if (e.code == "weak-password") {
                  await showErrorDialog(
                    context,
                    "Your password is too weak.\nPlease try again.",
                  );
                } else if (e.code == "email-already-in-use") {
                  await showErrorDialog(
                    context,
                    "Your email already registered.\nPlease login.",
                  );
                } else if (e.code == "invalid-email") {
                  await showErrorDialog(
                    context,
                    "Your email is invalid.\nPlease make it correct.",
                  );
                } else {
                  await showErrorDialog(
                    context,
                    "Error: ${e.code}",
                  );
                }
              } catch (e) {
                await showErrorDialog(
                  context,
                  e.toString(),
                );
              }
            },
            child: const Text('Register'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                loginRoute,
                (route) => false,
              );
            },
            child: const Text("Already have an account? Login here"),
          )
        ],
      ),
    );
  }
}
