// lib/service/auth_service.dart
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();

  late final Dio _dio;

  factory AuthService() {
    return _instance;
  }
  AuthService._internal() {
    _dio = Dio(BaseOptions(baseUrl: dotenv.env["BASE_URL"] ?? " "));
  }

  Future<Map<String, dynamic>> login(
      String username, String password, String? token) async {
    final response = await _dio.post(
      '/auth/login',
      data: {'username': username, 'password': password, 'fcmToken': token},
    );
    return response.data;
  }
}
