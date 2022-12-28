import 'package:learningdart/services/auth/exceptions.dart';
import 'package:learningdart/services/auth/provider.dart';
import 'package:learningdart/services/auth/user.dart';
import 'package:test/test.dart';

void main() {
  group('Mock Authentication', () {
    final provider = MockAuthProvider();
    test('Should not be initilized to begin with', () {
      expect(provider.isInitilized, false);
    });
    test('Cannot log out if not initilized', () {
      expect(
        provider.logout(),
        throwsA(const TypeMatcher<NotInitilizedException>()),
      );
    });
    test('Should be able to be initilized', () async {
      await provider.initialize();
      expect(provider.isInitilized, true);
    });
    test('User should be null just after initilization', () {
      expect(provider.currentUser, null);
    });
    test(
      'Should be able to initilize in less than 2 seconds',
      () async {
        await provider.initialize();
        expect(provider.isInitilized, true);
      },
      timeout: const Timeout(Duration(seconds: 2)),
    );
    test('Create user should delegate to login function', () async {
      // final badEmailUser = await provider.createUser(
      //   email: "foo@bar.com",
      //   password: "any",
      // );
      // expect(
      //   badEmailUser,
      //   throwsA(const TypeMatcher<UserNotFoundAuthException>()),
      // );
      // final badPasswordUser = await provider.createUser(
      //   email: "any@bar.com",
      //   password: "foobar",
      // );
      // expect(
      //   badPasswordUser,
      //   throwsA(const TypeMatcher<WrongPasswordAuthException>()),
      // );
      final user = await provider.createUser(
        email: 'email',
        password: 'password',
      );
      expect(provider.currentUser, user);
      expect(user.isEmailVerified, false);
    });
    test('Logged in user should be able to get verified', () async {
      await provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);
    });
    test('Should be able to log out and log in again', () async {
      await provider.logout();
      await provider.login(
        email: 'email',
        password: 'password',
      );
      final user = provider.currentUser;
      expect(user, isNotNull);
    });
  });
}

class NotInitilizedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  var _isInitilized = false;

  bool get isInitilized => _isInitilized;

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    return login(email: email, password: password);
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitilized = true;
  }

  @override
  Future<AuthUser> login({
    required String email,
    required String password,
  }) async {
    if (!isInitilized) throw NotInitilizedException();
    // if (email == 'foo@bar.com') throw UserNotFoundAuthException();
    // if (password == 'foobar') throw WrongPasswordAuthException();
    final user = AuthUser(isEmailVerified: false, email: email);
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logout() async {
    if (!isInitilized) throw NotInitilizedException();
    if (_user == null) throw UserNotFoundAuthException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitilized) throw NotInitilizedException();
    if (_user == null) throw UserNotFoundAuthException();
    await Future.delayed(const Duration(seconds: 1));
    final updatedUser = AuthUser(isEmailVerified: true, email: _user!.email);
    _user = updatedUser;
  }
}
