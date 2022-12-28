import 'package:learningdart/services/auth/user.dart';

abstract class AuthProvider {
  AuthUser? get currentUser;

  Future<AuthUser> login({
    required String email,
    required String password,
  });

  Future<AuthUser> createUser({
    required String email,
    required String password,
  });
  Future<void> logout();
  Future<void> sendEmailVerification();
  Future<void> initialize();
}
