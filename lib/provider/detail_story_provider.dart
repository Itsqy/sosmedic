import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sosmedic/data/api_service.dart';
import 'package:sosmedic/data/responses/stories_responses.dart';
import 'package:sosmedic/utils/result_state.dart';

class DetailStoryProvider extends ChangeNotifier {
  final String idStory;
  final ApiService apiService;

  DetailStoryProvider(this.idStory, this.apiService) {
    getDetailStory(idStory);
  }

  ResultState? _state;
  ResultState? get state => _state;

  ListStory _detailStory = ListStory();
  ListStory get detailStory => _detailStory;

  String _messageResponse = "";
  String get messageResponse => _messageResponse;

  Future<dynamic> getDetailStory(String id) async {
    _state = ResultState.loading;
    notifyListeners();
    return await apiService.getDetailStory(id).then((result) {
      if (result.error != true) {
        if (result.story != null) {
          _state = ResultState.hasData;
          _detailStory = result.story as ListStory;
          _messageResponse =
              result.message ?? "get detail Success already fetched";
        }
      } else {
        _state = ResultState.noData;
        _messageResponse = result.message ?? "no data please try again";
      }
    }).catchError((error) {
      if (error is SocketException) {
        _state = ResultState.error;
        _messageResponse = "Error: check Your COnnection";
      } else {
        _state = ResultState.error;
        _messageResponse = "Error: $error";
      }
    }).whenComplete(() {
      print("resultprovider :${state}");
      notifyListeners();
    });
  }
}
