// lib/features/auth/domain/auth_repository.dart
import '../../../core/error/result.dart';
import 'auth_user.dart';

/// Contract for authentication. Implementations must never throw across
/// this boundary: every operation returns a [Result].
abstract class AuthRepository {
  Future<Result<AuthUser>> signInWithEmail(String email, String password);

  Future<Result<AuthUser>> signUpWithEmail(String email, String password);

  /// Sends an SMS one-time code to [phone] (E.164).
  Future<Result<void>> signInWithOtp(String phone);

  Future<Result<AuthUser>> verifyOtp(String phone, String token);

  /// Launches the external OAuth flow. The resulting session (if any)
  /// arrives through [authStateChanges].
  Future<Result<void>> signInWithGoogle();

  Future<Result<void>> signInWithApple();

  Future<Result<void>> signOut();

  AuthUser? get currentUser;

  Stream<AuthUser?> authStateChanges();
}
