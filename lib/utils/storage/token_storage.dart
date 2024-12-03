import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Token管理类
class TokenStorage {
  static final TokenStorage instance = TokenStorage.init();

  factory TokenStorage() {
    return instance;
  }

  TokenStorage.init();

  static const _instance = FlutterSecureStorage();

  /// 检查是否存在Token
  static Future<bool> checkToken() async {
    var token = await _instance.read(key: 'accessToken');
    return token != null;
  }

  Future<void> setAccessToken(String accessToken) async {
    await _instance.write(key: 'accessToken', value: accessToken);
  }

  Future<void> setToken(String accessToken, String refreshToken) async {
    await _instance.write(key: 'accessToken', value: accessToken);
    await _instance.write(key: 'refreshToken', value: refreshToken);
  }

  Future<String> getAccessToken() async {
    String token = await _instance.read(key: 'accessToken') ?? '';
    return token;
  }

  Future<String> getRefreshToken() async {
    String token = await _instance.read(key: 'refreshToken') ?? '';
    return token;
  }

  Future<void> clearToken() async {
    await _instance.deleteAll();
  }
}
