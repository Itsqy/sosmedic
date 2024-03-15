import 'dart:convert';

import 'package:logger/logger.dart';
import 'package:sosmedic/data/request/login_request.dart';
import 'package:sosmedic/data/request/register_request.dart';
import 'package:sosmedic/data/responses/detail_story_response.dart';
import 'package:sosmedic/data/responses/login_response.dart';
import 'package:http/http.dart' as http;
import 'package:sosmedic/data/responses/stories_responses.dart';
import 'package:sosmedic/utils/auth_preference.dart';

class ApiService {
  static const String _url = "https://story-api.dicoding.dev/v1";

  Future<LoginResponse> login(LoginRequest userRequest) async {
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

  Future<LoginResponse> register(RegisterRequest userRequest) async {
    try {
      final request = await http.post(Uri.parse("$_url/register"),
          body: userRequest.toJson());
      print(request.body);
      var response = LoginResponse.fromJson(json.decode(request.body));
      return response;
    } on Exception catch (e) {
      var logger = Logger();
      logger.d(e.toString());
      throw Exception(e);
    }
  }

  Future<ListStoryResponse> fetchallStories() async {
    var authPref = AuthPreference();
    var userToken = await authPref.getUserToken();

    final request = await http.get(
      Uri.parse("$_url/stories"),
      headers: {
        'Authorization': 'Bearer $userToken',
      },
    ).timeout(
      Duration(seconds: 5),
    );

    var response = ListStoryResponse.fromJson(json.decode(request.body));
    print("response apiservice : ${response.listStory.toString()}");
    if (request.statusCode >= 200 && request.statusCode < 300) {
      print("${request.statusCode}");
      return response;
    } else {
      throw Exception("error : ${request.statusCode} - ${response.message}");
    }
  }

  Future<DetailStoryResponse> getDetailStory(String idStory) async {
    var authPref = AuthPreference();
    var userToken = await authPref.getUserToken();

    final request = await http.get(
      Uri.parse("$_url/stories/$idStory"),
      headers: {
        'Authorization': 'Bearer $userToken',
      },
    );

    var response = DetailStoryResponse.fromJson(json.decode(request.body));
    print("response apiservice : ${response.story.toString()}");
    if (request.statusCode >= 200 && request.statusCode < 300) {
      print("${request.statusCode}");
      return response;
    } else {
      throw Exception("error : ${request.statusCode} - ${response.message}");
    }
  }
}
