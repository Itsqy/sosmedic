import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:sosmedic/data/api_service.dart';
import 'package:sosmedic/provider/auth_provider.dart';
import 'package:sosmedic/utils/result_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen(
      {super.key, required this.onLogin, required this.onRegister});
  final VoidCallback onLogin;
  final VoidCallback onRegister;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
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
              Consumer<AuthProvider>(
                builder: (context, provider, _) {
                  switch (provider.stateLogin) {
                    case ResultState.hasData:
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        widget.onLogin.call();
                        Provider.of<AuthProvider>(context, listen: false)
                            .resetLoginState();
                      });

                      break;
                    case ResultState.noData:
                    case ResultState.error:
                      Fluttertoast.showToast(msg: provider.messageLogin);
                      break;
                    default:
                      break;
                  }
                  print("${provider.stateLogin}");
                  return ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        provider.userLogin(UserRequest(
                            email: emailController.text.trim(),
                            password: passwordController.text.trim()));
                      }
                      ;
                    },
                    child: Column(
                      children: [
                        if (provider.stateLogin == ResultState.loading) ...[
                          const Center(
                            child: CircularProgressIndicator(),
                          )
                        ],
                        const Center(child: Text("LOGIN"))
                      ],
                    ),
                  );
                },
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
