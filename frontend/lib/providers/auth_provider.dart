import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'package:bookstore/services/auth_service.dart';

final firebaseAuthProvider = Provider<FirebaseAuth?>((ref) {
  if (Platform.isLinux) return null;
  return FirebaseAuth.instance;
});

final authStateProvider = StreamProvider<User?>((ref) {
  if (Platform.isLinux) return Stream.value(null);
  final auth = ref.watch(firebaseAuthProvider);
  return auth!.authStateChanges();
});

class AuthNotifier extends StateNotifier<AsyncValue<void>> {
  final FirebaseAuth? _auth;
  String? _verificationId;

  AuthNotifier(this._auth) : super(const AsyncValue.data(null));

  // Step 1 — send OTP
  Future<void> sendOtp(String phoneNumber) async {
    if(_auth==null) return;
    state = const AsyncValue.loading();
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        state = AsyncValue.error(e.message ?? 'Verification failed', StackTrace.current);
      },
      codeSent: (String verificationId, int? resendToken) {
        _verificationId = verificationId;
        state = const AsyncValue.data(null);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
    );
  }

  // Step 2 — verify OTP
  Future<void> verifyOtp(String otp) async {
  if (_auth == null) return;
  state = const AsyncValue.loading();
  try {
    final credential = PhoneAuthProvider.credential(
      verificationId: _verificationId!,
      smsCode: otp,
    );
    await _auth!.signInWithCredential(credential);

    await AuthService.exchangeFirebaseToken();
    
    state = const AsyncValue.data(null);
  } catch (e) {
    state = AsyncValue.error('Invalid OTP. Please try again.', StackTrace.current);
  }
}

  Future<void> signOut() async {
    await _auth?.signOut();
  }
}

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<void>>((ref) {
  if (Platform.isLinux) return AuthNotifier(null);
  return AuthNotifier(ref.watch(firebaseAuthProvider)!);
});