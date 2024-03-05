import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:sosmedic/data/api_service.dart';
import 'package:sosmedic/utils/auth_preference.dart';
import 'package:sosmedic/utils/result_state.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService apiService;
  final AuthPreference authPreference;

  AuthProvider(this.authPreference, {required this.apiService});

  bool isLoadingLogin = false;
  bool isLoadingLogout = false;
  bool isLoadingRegister = false;

  ResultState? _stateLogin;
  ResultState? get stateLogin => _stateLogin;

  String _messageLogin = "";
  String get messageLogin => _messageLogin;

  bool _statusCode = true;
  bool get statusCode => _statusCode;

  Future<dynamic> userLogin(UserRequest userRequest) async {
    try {
      _stateLogin = ResultState.loading;
      notifyListeners();

      final loginResult = await apiService.login(userRequest);

      if (loginResult.error != true) {
        _stateLogin = ResultState.hasData;
        authPreference.setUserToken(loginResult.loginResult?.token ?? "");

        _messageLogin = loginResult.message ?? "Login Success";
      } else {
        _stateLogin = ResultState.noData;

        _messageLogin = loginResult.message ?? "Login Failed";
      }
    } on SocketException {
      _stateLogin = ResultState.error;

      _messageLogin = "Error: No Internet Connection";
    } catch (e) {
      _stateLogin = ResultState.error;

      _messageLogin = "Error: $e";
      print(messageLogin);
    } finally {
      notifyListeners();
    }
  }
}
