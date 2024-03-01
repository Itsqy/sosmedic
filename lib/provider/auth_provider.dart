import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:sosmedic/data/api_service.dart';
import 'package:sosmedic/utils/auth_preference.dart';
import 'package:sosmedic/utils/result_state.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService apiService;
  final AuthPreference authPreference;

  AuthProvider(this.authPreference, {required this.apiService});

  ResultState? _state;
  ResultState? get state => _state;

  String _message = "";
  String get message => _message;

  Future<dynamic> userLogin(UserRequest user) async {
    _state = ResultState.loading;
    notifyListeners();

    return apiService.login(user).then((loginResult) {
      if (!loginResult.error) {
        _state = ResultState.hasData;
        authPreference.setUserToken(loginResult.loginResult.token ?? "");
        _message = loginResult.message;
      } else {
        _state = ResultState.noData;
        _message = loginResult.message;
      }
    }).catchError((error) {
      if (error is SocketException) {
        _state = ResultState.error;
        _message = "Error: No Internet Connection";
      } else {
        _state = ResultState.error;
        _message = "Error: $error";
      }
    }).whenComplete(() {
      notifyListeners();
    });
  }
}
