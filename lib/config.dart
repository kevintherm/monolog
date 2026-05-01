import 'dart:io';
import 'package:flutter/foundation.dart';

class AppConfig {
  AppConfig._();

  static const String env = "production"; // local, production

  static const String domain = 'chantal-strawless-ulcerously.ngrok-free.dev';

  static String get apiUrl {
    if (!kIsWeb && Platform.isAndroid && env == "local") {
      return 'http://10.0.2.2';
    }
    return 'https://$domain';
  }

  static const String realtimeAppKey = 'somerandomstring';
  static const String realtimeAppId = '123456';

  static const String usersCollection = 'users';
  static const String daysCollection = 'days';
  static const String mealsCollection = 'meals';
  static const String workoutsCollection = 'workouts';

  static const String googleServerClientId =
      '1086955624571-kn193njqd2seucr92bj109o9v6sofp0u.apps.googleusercontent.com';
}
