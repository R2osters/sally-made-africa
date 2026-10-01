// lib/features/auth/domain/auth_user.dart

/// Authenticated user of the app. Equality is based on [id] only.
class AuthUser {
  final String id;
  final String? email;
  final String? phone;
  final String? displayName;

  const AuthUser({
    required this.id,
    this.email,
    this.phone,
    this.displayName,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is AuthUser && other.id == id);

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'AuthUser(id: $id, email: $email, phone: $phone)';
}
