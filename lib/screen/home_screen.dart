import 'package:flutter/material.dart';
import 'package:sosmedic/utils/auth_preference.dart';

class HomeScreen extends StatelessWidget {
  final Function() onLogout;
  const HomeScreen({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(child: Text("HOme")),
      floatingActionButton: OutlinedButton(
          onPressed: () {
            var authProf = AuthPreference();
            authProf.setUserToken("");
            onLogout();
          },
          child: const Text("logout")),
    );
  }
}
