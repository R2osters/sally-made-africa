// test/helpers/fake_auth_repository.dart
import 'dart:async';

import 'package:travelconnect/core/error/failure.dart';
import 'package:travelconnect/core/error/result.dart';
import 'package:travelconnect/features/auth/domain/auth_repository.dart';
import 'package:travelconnect/features/auth/domain/auth_user.dart';

/// Scriptable in-memory [AuthRepository] for tests.
///
/// Set [nextFailure] to make the next operation fail. Push users into
/// [stateController] (or call [emitSignedIn]/[emitSignedOut]) to drive
/// [authStateChanges].
class FakeAuthRepository implements AuthRepository {
  final stateController = StreamController<AuthUser?>.broadcast();

  Failure? nextFailure;
  AuthUser? _currentUser;

  /// Log of method invocations, e.g. 'signInWithEmail(a@b.com)'.
  final List<String> calls = [];

  static const defaultUser = AuthUser(id: 'fake-user', email: 'a@b.com');

  void emitSignedIn([AuthUser user = defaultUser]) {
    _currentUser = user;
    stateController.add(user);
  }

  void emitSignedOut() {
    _currentUser = null;
    stateController.add(null);
  }

  Result<T> _scripted<T>(T value) {
    final failure = nextFailure;
    if (failure != null) {
      nextFailure = null;
      return Error<T>(failure);
    }
    return Success<T>(value);
  }

  @override
  Future<Result<AuthUser>> signInWithEmail(
      String email, String password) async {
    calls.add('signInWithEmail($email)');
    final r = _scripted(AuthUser(id: 'fake-user', email: email));
    if (r case Success<AuthUser>(value: final u)) _currentUser = u;
    return r;
  }

  @override
  Future<Result<AuthUser>> signUpWithEmail(
      String email, String password) async {
    calls.add('signUpWithEmail($email)');
    final r = _scripted(AuthUser(id: 'fake-user', email: email));
    if (r case Success<AuthUser>(value: final u)) _currentUser = u;
    return r;
  }

  @override
  Future<Result<void>> signInWithOtp(String phone) async {
    calls.add('signInWithOtp($phone)');
    return _scripted(null);
  }

  @override
  Future<Result<AuthUser>> verifyOtp(String phone, String token) async {
    calls.add('verifyOtp($phone, $token)');
    final r = _scripted(AuthUser(id: 'fake-user', phone: phone));
    if (r case Success<AuthUser>(value: final u)) _currentUser = u;
    return r;
  }

  @override
  Future<Result<void>> signInWithGoogle() async {
    calls.add('signInWithGoogle');
    return _scripted(null);
  }

  @override
  Future<Result<void>> signInWithApple() async {
    calls.add('signInWithApple');
    return _scripted(null);
  }

  @override
  Future<Result<void>> signOut() async {
    calls.add('signOut');
    final r = _scripted<void>(null);
    if (r.isSuccess) {
      _currentUser = null;
      stateController.add(null);
    }
    return r;
  }

  @override
  AuthUser? get currentUser => _currentUser;

  @override
  Stream<AuthUser?> authStateChanges() => stateController.stream;

  void dispose() {
    stateController.close();
  }
}
