import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen(
      {super.key, required this.onLogin, required this.onRegister});
  final Function() onLogin;
  final Function() onRegister;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 300),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.account_circle,
                size: 100,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email.';
                  }
                  return null;
                },
                decoration: const InputDecoration(hintText: "input email"),
              ),
              const SizedBox(
                height: 8,
              ),
              TextFormField(
                controller: passwordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password.';
                  }
                  return null;
                },
                decoration: const InputDecoration(hintText: "input password"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    // final User user = User(
                    //   name: emailController.text,
                    //   tokenAuth:
                    // )
                  } else {}
                },
                child: const Text("LOGIN"),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: () {
                  widget.onRegister();
                },
                child: const Text("REGISTER"),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
