import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:bookstore/core/api_client.dart';

class AuthService {
  static const _storage = FlutterSecureStorage();
  static const _jwtKey = 'jwt_token';
  static const _roleKey = 'user_role';

  // Called after Firebase OTP verification
  static Future<void> exchangeFirebaseToken() async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('DEBUG: No Firebase user found');
      return;
    }
    print('DEBUG: Firebase user found: ${user.uid}');
    
    final firebaseToken = await user.getIdToken();
    print('DEBUG: Got Firebase token');

    final response = await ApiClient.dio.post(
      '/auth/verify',
      data: {'firebaseToken': firebaseToken},
    );
    print('DEBUG: Spring Boot response: ${response.data}');

    await _storage.write(key: _jwtKey, value: response.data['token']);
    await _storage.write(key: _roleKey, value: response.data['role']);
    print('DEBUG: JWT stored successfully');
  } catch (e) {
    print('DEBUG: exchangeFirebaseToken error: $e');
  }
}

  static Future<String?> getJwt() async {
    return await _storage.read(key: _jwtKey);
  }

  static Future<String?> getRole() async {
    return await _storage.read(key: _roleKey);
  }

  static Future<void> clearTokens() async {
    await _storage.deleteAll();
  }
}