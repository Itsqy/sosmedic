import 'package:shared_preferences/shared_preferences.dart';
import 'package:sosmedic/data/model/user.dart';

class AuthRepository {
  final String stateKey = "state";
  final String userDataKey = "userData";

  // status

  Future<bool> isLoggedIn() async {
    final pref = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(seconds: 2));
    return pref.getBool(stateKey) ?? false;
  }

  Future<bool> login() async {
    final pref = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(seconds: 2));
    return pref.setBool(stateKey, true);
  }

  Future<bool> logout() async {
    final pref = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(seconds: 2));
    return pref.setBool(stateKey, false);
  }

  // user data

  Future<bool> saveUser(User user) async {
    final pref = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(seconds: 2));
    return pref.setString(userDataKey, user.toJson());
  }

  Future<bool> deleteUser() async {
    final pref = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(seconds: 2));
    return pref.setString(userDataKey, "");
  }

  Future<User?> getUser() async {
    final pref = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(seconds: 2));
    final json = pref.getString(userDataKey) ?? "";
    User? user;
    try {
      user = User.fromJson(json);
    } catch (e) {
      user == null;
    }
    return user;
  }
}
