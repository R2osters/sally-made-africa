import 'dart:async';
import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart' hide AuthUser;

import '../../../core/error/failure.dart';
import '../../../core/error/result.dart';
import '../domain/auth_repository.dart';
import '../domain/auth_user.dart';

/// Adapter over `supabase.auth`. Never throws across the [AuthRepository]
/// boundary: every operation is wrapped in [_guard] and returns a [Result].
class SupabaseAuthRepository implements AuthRepository {
  final SupabaseClient _supabase;

  SupabaseAuthRepository(this._supabase);

  GoTrueClient get _auth => _supabase.auth;

  @override
  Future<Result<AuthUser>> signInWithEmail(String email, String password) {
    return _guard(() async {
      final res = await _auth.signInWithPassword(
        email: email,
        password: password,
      );
      return _requireUser(res.user);
    });
  }

  @override
  Future<Result<AuthUser>> signUpWithEmail(String email, String password) {
    return _guard(() async {
      final res = await _auth.signUp(email: email, password: password);
      return _requireUser(res.user);
    });
  }

  @override
  Future<Result<void>> signInWithOtp(String phone) {
    return _guard(() async {
      await _auth.signInWithOtp(phone: phone);
    });
  }

  @override
  Future<Result<AuthUser>> verifyOtp(String phone, String token) {
    return _guard(() async {
      final res = await _auth.verifyOTP(
        type: OtpType.sms,
        phone: phone,
        token: token,
      );
      return _requireUser(res.user);
    });
  }

  @override
  Future<Result<void>> signInWithGoogle() {
    return _guard(() async {
      await _auth.signInWithOAuth(OAuthProvider.google);
    });
  }

  @override
  Future<Result<void>> signInWithApple() {
    return _guard(() async {
      await _auth.signInWithOAuth(OAuthProvider.apple);
    });
  }

  @override
  Future<Result<void>> signOut() {
    return _guard(() async {
      await _auth.signOut();
    });
  }

  @override
  AuthUser? get currentUser => _mapUser(_auth.currentUser);

  @override
  Stream<AuthUser?> authStateChanges() {
    return _auth.onAuthStateChange.map((data) => _mapUser(data.session?.user));
  }

  /// Maps a supabase [User] to the domain [AuthUser], or null.
  AuthUser? _mapUser(User? user) {
    if (user == null) return null;
    return AuthUser(
      id: user.id,
      email: user.email,
      phone: user.phone,
      displayName: user.userMetadata?['display_name'] as String?,
    );
  }

  /// Like [_mapUser] but for flows that must yield a user; throws if absent
  /// so [_guard] converts it into an [AuthFailure].
  AuthUser _requireUser(User? user) {
    final mapped = _mapUser(user);
    if (mapped == null) {
      throw const AuthException('No user returned by the authentication call.');
    }
    return mapped;
  }

  /// Runs [action], mapping any exception to a [Failure]:
  /// [AuthException] -> [AuthFailure], socket/timeout -> [NetworkFailure],
  /// everything else -> [UnknownFailure].
  Future<Result<T>> _guard<T>(Future<T> Function() action) async {
    try {
      return Success(await action());
    } on AuthException catch (e) {
      return Error(AuthFailure(e.message));
    } on SocketException catch (e) {
      return Error(NetworkFailure(e.message));
    } on TimeoutException catch (e) {
      return Error(NetworkFailure(e.message ?? 'Request timed out.'));
    } catch (e) {
      return Error(UnknownFailure(e.toString()));
    }
  }
}
