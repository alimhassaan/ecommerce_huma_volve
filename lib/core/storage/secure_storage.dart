import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static final storage = FlutterSecureStorage();

  static Future<void> saveAccessToken(String? token) async {
    await storage.write(key: 'access_token', value: token);
  }

  static Future<void> saveRefreshToken(String? token) async {
    await storage.write(key: 'refresh_token', value: token);
  }

  static Future<String?> getAccessToken() async {
    return await storage.read(key: 'access_token');
  }

  static Future<String?> getRefreshToken() async {
    return await storage.read(key: 'refresh_token');
  }

  static Future<void> saveProfile({
    required String name,
    required String email,
    String? avatar,
  }) async {
    await storage.write(key: 'user_name', value: name);
    await storage.write(key: 'user_email', value: email);
    if (avatar != null) {
      await storage.write(key: 'user_avatar', value: avatar);
    }
  }

  static Future<Map<String, String?>> getProfile() async {
    return {
      'name': await storage.read(key: 'user_name'),
      'email': await storage.read(key: 'user_email'),
      'avatar': await storage.read(key: 'user_avatar'),
    };
  }

  static Future<void> deleteTokens() async {
    return await storage.deleteAll();
  }
}
