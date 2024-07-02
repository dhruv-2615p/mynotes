import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/auth/auth_user.dart';
import 'package:test/test.dart';

void main() {
  group("Mock Authprovider", () {
    final provider = MockAuthProvider();
    test('Should not be initialized to begin with', () {
      expect(provider._isInitialized, false);
    });

    test('Cannot log out if not initialized', () {
      expect(
        provider.logOut(),
        throwsA(const TypeMatcher<NotInitializedException>()),
      );
    });

    test("Should be able to initialized", () async {
      await provider.initialize();
      expect(provider.isInitialized, true);
    });

    test('User should be null after initialization', () {
      expect(provider.currentUser, null);
    });

    test(
      'Should be able to initialize in less then 2 second',
      () async {
        await provider.initialize();
        expect(provider.isInitialized, true);
      },
      timeout: const Timeout(Duration(seconds: 2)),
    );

    test('Create user should delegate to logIn function', () async {
      // final badEmailUser = await provider.createUser(
      //   email: 'dhruv@gmail.com',
      //   password: 'dshitu',
      // );

      // expect(badEmailUser,
      //     throwsA(const TypeMatcher<UserNotFoundAuthException>()));

      await expectLater(
        provider.createUser(email: 'dhruv@gmail.com', password: 'dshitu'),
        throwsA(isA<UserNotFoundAuthException>()),
      );

      // final badPasswordUser = await provider.createUser(
      //   email: 'someone@gmail.com',
      //   password: 'Dhruv',
      // );

      // expect(badPasswordUser,
      //     throwsA(const TypeMatcher<WeakPasswordAuthException>()));

      await expectLater(
        provider.createUser(email: 'someone@gmail.com', password: 'Dhruv'),
        throwsA(isA<WrongPasswordAuthException>()),
      );

      final user = await provider.createUser(
        email: 'xyzwef@gmil.com',
        password: 'password',
      );

      expect(provider.currentUser, user);
      expect(user.isEmailVerified, false);
    });

    test('Logged in user should be able to get verified', () async {
      await provider.createUser(
          email: 'test@example.com', password: 'password');
      await provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user?.isEmailVerified, true);
    });

    test('Should be able to log out and log in again', () async {
      await provider.createUser(
          email: 'test@example.com', password: 'password');
      await provider.logOut();
      await provider.logIn(
        email: 'email',
        password: 'password',
      );
      final user = provider.currentUser;
      expect(user, isNotNull);
    });

    // test('Should reload user data', () async {
    //   await provider.createUser(
    //       email: 'test@example.com', password: 'password');
    //   await provider.reloadUser();
    //   final user = provider.currentUser;
    //   expect(user, isNotNull);
    //   expect(user?.isEmailVerified, true); // Assuming user is verified after reload
    // });


  });
}

class NotInitializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;

  var _isInitialized = false;
  bool get isInitialized => _isInitialized;

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) throw NotInitializedException();
    await Future.delayed(const Duration(seconds: 1));
    return logIn(
      email: email,
      password: password,
    );
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) {
    if (!isInitialized) throw NotInitializedException();

    if (email == 'dhruv@gmail.com') throw UserNotFoundAuthException();

    if (password == "Dhruv") throw WrongPasswordAuthException();

    const user = AuthUser(
      isEmailVerified: false,
      email: 'dhrupx@gmail.com',
      id: 'my_id',
    );
    _user = user;

    return Future.value(user);
  }

  @override
  Future<void> logOut() async {
    if (!isInitialized) throw NotInitializedException();
    if (_user == null) throw UserNotFoundAuthException();

    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialized) throw NotInitializedException();
    final user = _user;
    if (user == null) throw UserNotFoundAuthException();

    const newUser =
        AuthUser(isEmailVerified: true, email: 'xyzd@gmail.com', id: 'my_id');
    _user = newUser;
  }
  
  @override
  Future<void> reloadUser() async {
    if (!isInitialized) throw NotInitializedException();
    // Simulate reloading user data
    if (_user != null) {
      _user = AuthUser(
        isEmailVerified: true, // Assume the user has been verified for the test
        email: _user!.email,
        id: _user!.id,
      );
    } else {
      throw UserNotLoggedInAuthException();
    }
  }
  
  @override
  Future<void> sendPasswordReset({required String toEmail}) {
    throw UnimplementedError();
  }
}
