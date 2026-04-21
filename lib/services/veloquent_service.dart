import 'package:flutter/foundation.dart';
import 'package:veloquent_sdk/veloquent_sdk.dart';
import '../config.dart';

class VeloquentService {
  VeloquentService._();
  static VeloquentService? _instance;
  static VeloquentService get instance {
    _instance ??= VeloquentService._();
    return _instance!;
  }

  late Veloquent sdk;

  Future<void> init() async {
    sdk = Veloquent(
      apiUrl: AppConfig.apiUrl,
      http: createFetchAdapter(),
      storage: await createLocalStorageAdapter(),
    );
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    return await sdk.auth.login(AppConfig.usersCollection, email, password);
  }

  Future<Map<String, dynamic>> me() async {
    return await sdk.auth.me(AppConfig.usersCollection);
  }

  Future<dynamic> register(String name, String email, String password) async {
    return await sdk.records.create(AppConfig.usersCollection, {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': password,
    });
  }

  Future<void> logout() async {
    try {
      await sdk.auth.logout(AppConfig.usersCollection);
    } catch (e) {
      debugPrint('Logout error (handled): $e');
    }
  }

  Future<bool> hasSession() async {
    try {
      await sdk.auth.me(AppConfig.usersCollection);
      return true;
    } catch (_) {
      return false;
    }
  }
}
