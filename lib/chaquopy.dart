import 'dart:async';

import 'package:flutter/services.dart';

/// static class for accessing the executeCode function.
class Chaquopy {
  static const MethodChannel _channel = const MethodChannel('chaquopy');

  /// This function execute your python code and returns result Map.
  /// Structure of result map is :
  /// result['textOutput'] : The original output / error
  static Future<Map<String, dynamic>> executeCode(String code) async {
    dynamic outputData = await _channel.invokeMethod('runPythonScript', code).onError((error, stackTrace) {
      throw Exception(error);
    });
    return Map<String, dynamic>.from(outputData);
  }

  static Future<bool> pythonServiceIsStarted() async {
    final result = await _channel.invokeMethod('isStarted').onError((error, stackTrace) {
      throw Exception(error);
    });
    return result;
  }

  static Future<bool> startService() async {
    final result = await _channel.invokeMethod('start').onError((error, stackTrace) {
      throw Exception(error);
    });
    return result;
  }
}
