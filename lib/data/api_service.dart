import 'dart:convert';

import 'package:sosmedic/data/responses/login_response.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _url = "https://story-api.dicoding.dev/v1";

  Future<LoginResponse> login(UserRequest userRequest) async {
    final request =
        await http.post("$_url/login" as Uri, body: userRequest.toJson());
    var response = LoginResponse.fromJson(json.decode(request.body));
    switch (request.statusCode) {
      case >= 200 && < 300:
        return response;
      default:
        throw Exception("error : ${response.message}");
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
