import 'dart:io';
import 'package:flutter/foundation.dart';

class AppConfig {
  AppConfig._();

  static const String domain = 'monolog.localhost';
  
  static String get apiUrl {
    if (!kIsWeb && Platform.isAndroid) {
      return 'http://10.0.2.2';
    }
    return 'http://$domain';
  }

  static const String realtimeAppKey = 'somerandomstring';
  static const String realtimeAppId = '123456';

  static const String usersCollection = 'users';
  static const String daysCollection = 'days';
  static const String mealsCollection = 'meals';
  static const String workoutsCollection = 'workouts';
}
