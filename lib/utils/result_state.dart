import 'package:flutter/material.dart';

enum ResultState { loading, noData, hasData, error }

afterBuildWidgetCallback(VoidCallback callback) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    callback.call();
  });
}
