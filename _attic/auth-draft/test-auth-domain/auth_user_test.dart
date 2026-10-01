// test/features/auth/domain/auth_user_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:travelconnect/core/error/failure.dart';
import 'package:travelconnect/features/auth/domain/auth_user.dart';

void main() {
  group('AuthUser', () {
    test('equality is based on id only', () {
      const a = AuthUser(id: 'u1', email: 'a@b.com');
      const b = AuthUser(id: 'u1', email: 'other@b.com');
      const c = AuthUser(id: 'u2', email: 'a@b.com');

      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
      expect(a, isNot(equals(c)));
    });

    test('holds optional fields', () {
      const u = AuthUser(
        id: 'u1',
        email: 'a@b.com',
        phone: '+22890000000',
        displayName: 'Léo',
      );
      expect(u.email, 'a@b.com');
      expect(u.phone, '+22890000000');
      expect(u.displayName, 'Léo');
    });
  });

  group('AuthFailure', () {
    test('is a Failure with a message', () {
      const f = AuthFailure('invalid credentials');
      expect(f, isA<Failure>());
      expect(f.message, 'invalid credentials');
    });
  });
}
