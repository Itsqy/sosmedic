import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sosmedic/data/api_service.dart';
import 'package:sosmedic/provider/auth_provider.dart';
import 'package:sosmedic/utils/result_state.dart';

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
    var watchAuth = context.watch<AuthProvider>();
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
              // Consumer<AuthProvider>(
              //   builder: (context, provider, _) {
              //     return ElevatedButton(
              //       onPressed: () async {
              //         if (formKey.currentState!.validate()) {
              //           provider.userLogin(UserRequest(
              //               email: emailController.text,
              //               password: passwordController.text));

              //           provider.stateLogin == ResultState.hasData
              //               ? widget.onLogin()
              //               : null;
              //         }
              //         ;
              //       },
              //       child: Row(
              //         children: [
              //           if (provider.stateLogin == ResultState.loading) ...[
              //             const Center(
              //               child: CircularProgressIndicator(),
              //             )
              //           ],
              //           const Text("Login")
              //         ],
              //       ),
              //     );
              //   },
              // ),

              watchAuth.isLoadingLogin
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          final UserRequest user = UserRequest(
                            email: emailController.text,
                            password: passwordController.text,
                          );

                          final authRead = context.read<AuthProvider>();
                          final result = authRead.userLogin(user);
                          print("authread : $result");
                          debugPrint("stateLogin :${watchAuth.stateLogin} ");

                          if (watchAuth.messageLogin == "success") {
                            debugPrint("stateLogin :${watchAuth.stateLogin} ");
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(authRead.messageLogin)));
                            widget.onLogin();
                          } else {
                            debugPrint(
                                "stateLoginElse :${authRead.stateLogin} ");
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(authRead.messageLogin)));
                          }
                        }
                      },
                      child: const Text("Login")),

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
