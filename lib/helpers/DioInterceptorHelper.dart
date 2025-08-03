import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart'; // for navigatorKey

class DioInterceptorHelper {
  static bool _isRedirectingToLogin = false;

  static InterceptorsWrapper createInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('jwt_token');
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (DioException e, handler) async {
        if ((e.response?.statusCode == 401 || e.response?.statusCode == 403) &&
            !_isRedirectingToLogin) {
          _isRedirectingToLogin = true;

          final prefs = await SharedPreferences.getInstance();
          await prefs.remove('jwt_token');
          await prefs.remove('user_id');
          await prefs.remove('username');

          Future.delayed(Duration.zero, () {
            try {
              navigatorKey.currentState?.pushNamedAndRemoveUntil(
                '/login',
                (route) => false,
              );
            } catch (_) {
            } finally {
              _isRedirectingToLogin = false;
            }
          });

          handler.reject(
            DioException(
              requestOptions: e.requestOptions,
              response: e.response,
              type: DioExceptionType.badResponse,
              error: "Unauthorized, redirected to login",
            ),
          );
          return;
        }

        return handler.next(e);
      },
    );
  }
}
