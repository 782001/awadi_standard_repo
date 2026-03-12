import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageHelper {
  final FlutterSecureStorage _storage;

  SecureStorageHelper(this._storage);

  /// Save a value securely
  Future<void> saveData({required String key, required String value}) async {
    await _storage.write(key: key, value: value);
  }

  /// Read a value securely
  Future<String?> getData({required String key}) async {
    return await _storage.read(key: key);
  }

  /// Remove a value securely
  Future<void> deleteData({required String key}) async {
    await _storage.delete(key: key);
  }

  /// Clear all secure data
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
