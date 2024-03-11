import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:sosmedic/data/api_service.dart';
import 'package:sosmedic/data/request/login_request.dart';
import 'package:sosmedic/data/request/register_request.dart';
import 'package:sosmedic/utils/auth_preference.dart';
import 'package:sosmedic/utils/result_state.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService apiService;
  final AuthPreference authPreference;

  AuthProvider(this.authPreference, {required this.apiService});

  ResultState? _stateLogin;
  ResultState? get stateLogin => _stateLogin;

  String _messageLogin = "";
  String get messageLogin => _messageLogin;

  ResultState? _stateRegister;
  ResultState? get stateRegister => _stateRegister;

  String _messageRegister = "";
  String get messageRegister => _messageRegister;

  Future<dynamic> userLogin(LoginRequest userRequest) async {
    _stateLogin = ResultState.loading;
    notifyListeners();

    return await apiService.login(userRequest).then((result) {
      if (result.error != true) {
        _stateLogin = ResultState.hasData;
        authPreference.setUserToken(result.loginResult!.token);
        _messageLogin = result.message ?? " You just Created an Account";
      } else {
        _stateLogin = ResultState.noData;
        _messageLogin = result.message ?? "Register failed please try again";
      }
    }).catchError((error) {
      if (error is SocketException) {
        _stateLogin = ResultState.error;
        _messageLogin = "Error: No Internet Connection";
      } else {
        _stateLogin = ResultState.error;
        _messageLogin = "Error: $error";
      }
    }).whenComplete(() {
      notifyListeners();
    });
  }

  Future<dynamic> userRegister(RegisterRequest userRequest) async {
    _stateRegister = ResultState.loading;
    notifyListeners();
    return await apiService.register(userRequest).then((result) {
      if (result.error != true) {
        _stateRegister = ResultState.hasData;
        _messageRegister = result.message ?? " You just Created an Account";
      } else {
        _stateRegister = ResultState.noData;
        _messageRegister = result.message ?? "Register failed please try again";
      }
    }).catchError((error) {
      if (error is SocketException) {
        _stateRegister = ResultState.error;
        _messageRegister = "Error: No Internet Connection";
      } else {
        _stateRegister = ResultState.error;
        _messageRegister = "Error: $error";
      }
    }).whenComplete(() {
      notifyListeners();
    });
  }
}
