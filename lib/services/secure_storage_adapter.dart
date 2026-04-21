import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:veloquent_sdk/veloquent_sdk.dart';

class SecureStorageAdapter extends StorageAdapter {
  final FlutterSecureStorage _storage;

  SecureStorageAdapter({
    FlutterSecureStorage? storage,
  }) : _storage = storage ?? const FlutterSecureStorage();

  @override
  bool get isAsync => true;

  @override
  String? getItem(String key) => null;

  @override
  void setItem(String key, String value) {}

  @override
  void removeItem(String key) {}

  @override
  void clear() {}

  @override
  Future<String?> getItemAsync(String key) async {
    return await _storage.read(key: key);
  }

  @override
  Future<void> setItemAsync(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  @override
  Future<void> removeItemAsync(String key) async {
    await _storage.delete(key: key);
  }

  @override
  Future<void> clearAsync() async {
    await _storage.deleteAll();
  }
}
