import 'package:dio/dio.dart';
import '../services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'config.dart';
class ApiClient {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  static void init() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (options.path.contains('/auth/')) {
            return handler.next(options);
          }
          final jwt = await AuthService.getJwt();
          if (jwt != null) {
            options.headers['Authorization'] = 'Bearer $jwt';
          }
          return handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            await AuthService.clearTokens();
            await FirebaseAuth.instance.signOut();
          }
          return handler.next(error);
        },
      ),
    );
  }
}