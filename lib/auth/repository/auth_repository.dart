// lib/repository/auth_repository.dart
import 'package:shared_preferences/shared_preferences.dart';
import '../service/auth_service.dart';

class AuthRepository {
  final AuthService _authService;

  AuthRepository(this._authService);

  Future<bool> login(String username, String password) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? fcmToken = await prefs.getString("fcm_token");
      final data = await _authService.login(username, password, fcmToken);
      final token = data['data']['token'];
      final userId = data['data']['userId'];
      final userName = data['data']['username'];
      await prefs.setString('jwt_token', token);
      await prefs.setString('user_id', userId);
      await prefs.setString('username', userName);

      return true;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }
}
