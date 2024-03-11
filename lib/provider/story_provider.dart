import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sosmedic/data/api_service.dart';
import 'package:sosmedic/data/responses/stories_responses.dart';
import 'package:sosmedic/utils/result_state.dart';

class StoryProvider extends ChangeNotifier {
  final ApiService apiService;

  StoryProvider(this.apiService) {
    allStories();
  }

  String _messageGetStories = "";
  String get messageGetStories => _messageGetStories;

  List<ListStory> get storiesData => _storiesData;
  List<ListStory> _storiesData = [];

  ResultState? _stateGetStories;
  ResultState? get stateGetStories => _stateGetStories;

  Future<dynamic> allStories() async {
    _stateGetStories = ResultState.loading;
    notifyListeners();

    return await apiService.fetchallStories().then((result) {
      print("resultprovider :${result.listStory}");
      if (result.error != true) {
        if (result.listStory!.isNotEmpty) {
          _stateGetStories = ResultState.hasData;
          // _storiesData.clear();
          // _storiesData.addAll(result.listStory ?? List.empty());
          _storiesData =
              result.listStory != null ? List.from(result.listStory ?? []) : [];
          _messageGetStories = result.message ?? "data already fetched";
        }
      } else {
        _stateGetStories = ResultState.noData;
        _messageGetStories = result.message ?? "no data please try again";
      }
    }).catchError((error) {
      if (error is SocketException) {
        _stateGetStories = ResultState.error;
        _messageGetStories = "Error: No Internet Connection";
      } else {
        _stateGetStories = ResultState.error;
        _messageGetStories = "Error: $error";
      }
    }).whenComplete(() {
      notifyListeners();
    });
  }
}
