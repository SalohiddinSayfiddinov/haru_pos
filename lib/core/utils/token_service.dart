import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class TokenService {
  Future<void> saveAccessToken(String token);
  Future<void> saveRefreshToken(String token);
  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
  Future<void> clearTokens();
  Future<bool> hasTokens();
}

@LazySingleton(as: TokenService)
class TokenServiceImpl implements TokenService {
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

  final SharedPreferences _prefs;

  TokenServiceImpl(this._prefs);

  @override
  Future<void> saveAccessToken(String token) async {
    _prefs.setString(_accessTokenKey, token);
  }

  @override
  Future<void> saveRefreshToken(String token) async {
    _prefs.setString(_refreshTokenKey, token);
  }

  @override
  Future<String?> getAccessToken() async {
    return _prefs.getString(_accessTokenKey);
  }

  @override
  Future<String?> getRefreshToken() async {
    return _prefs.getString(_refreshTokenKey);
  }

  @override
  Future<void> clearTokens() async {
    _prefs.remove(_accessTokenKey);
    _prefs.remove(_refreshTokenKey);
  }

  @override
  Future<bool> hasTokens() async {
    final accessToken = await getAccessToken();
    final refreshToken = await getRefreshToken();
    return accessToken != null && refreshToken != null;
  }
}