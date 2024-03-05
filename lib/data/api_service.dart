import 'dart:convert';

import 'package:logger/logger.dart';
import 'package:sosmedic/data/responses/login_response.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _url = "https://story-api.dicoding.dev/v1";

  Future<LoginResponse> login(UserRequest userRequest) async {
    try {
      final request =
          await http.post(Uri.parse("$_url/login"), body: userRequest.toJson());
      print(request.body);
      var response = LoginResponse.fromJson(json.decode(request.body));
      return response;
    } on Exception catch (e) {
      var logger = Logger();
      logger.d(e.toString());
      throw Exception(e);
    }
  }
}

class UserRequest {
  String? email;
  String? password;

  UserRequest({this.email, this.password});

  UserRequest.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['password'] = password;
    return data;
  }
}
