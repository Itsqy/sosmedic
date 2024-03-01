import 'package:shared_preferences/shared_preferences.dart';

class AuthPreference {
  static const userToken = "userToken";

  setUserToken(String token) async {
    final pref = await SharedPreferences.getInstance();
    pref.setString(userToken, token);
  }

  Future<String> getUserToken() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString(userToken) ?? "";
  }
}
