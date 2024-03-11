import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:sosmedic/data/api_service.dart';
import 'package:sosmedic/data/request/register_request.dart';
import 'package:sosmedic/provider/auth_provider.dart';
import 'package:sosmedic/utils/auth_preference.dart';
import 'package:sosmedic/utils/result_state.dart';

class RegisterScreen extends StatefulWidget {
  final Function onLogin;
  final Function onRegisterSuccesful;
  const RegisterScreen(
      {super.key, required this.onLogin, required this.onRegisterSuccesful});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
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
        body: ChangeNotifierProvider<AuthProvider>(
      create: (context) =>
          AuthProvider(AuthPreference(), apiService: ApiService()),
      child: Center(
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
                  controller: nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your nickname.';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(hintText: "input nickname"),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: emailController,
                  obscureText: true,
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
                Consumer<AuthProvider>(builder: (context, provider, _) {
                  print("stateregister : ${provider.stateRegister}");
                  switch (provider.stateRegister) {
                    case ResultState.hasData:
                      if (provider.messageRegister.isNotEmpty &&
                          provider.messageRegister != null) {
                        Fluttertoast.showToast(msg: provider.messageRegister);
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          widget.onRegisterSuccesful.call();
                        });
                      }
                      Fluttertoast.showToast(msg: provider.messageRegister);

                      break;
                    case ResultState.noData:
                    case ResultState.error:
                      Fluttertoast.showToast(msg: provider.messageRegister);
                      break;
                    default:
                      break;
                  }

                  return ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        provider.userRegister(RegisterRequest(
                          name: nameController.text.trim(),
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                        ));
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (provider.stateRegister == ResultState.loading)
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(),
                          )
                        else
                          const Text("REGISTER")
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: () {
                    widget.onLogin();
                  },
                  child: const Text("LOGIN"),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
