// test/helpers/fake_auth_repository_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:travelconnect/core/error/failure.dart';
import 'package:travelconnect/core/error/result.dart';
import 'package:travelconnect/features/auth/domain/auth_user.dart';

import 'fake_auth_repository.dart';

void main() {
  group('FakeAuthRepository', () {
    late FakeAuthRepository repo;

    setUp(() => repo = FakeAuthRepository());
    tearDown(() => repo.dispose());

    test('successful email sign-in returns user and sets currentUser',
        () async {
      final r = await repo.signInWithEmail('a@b.com', 'password123');
      expect(r.isSuccess, isTrue);
      expect(r.valueOrNull?.email, 'a@b.com');
      expect(repo.currentUser, isNotNull);
      expect(repo.calls, contains('signInWithEmail(a@b.com)'));
    });

    test('scripted failure is returned once then cleared', () async {
      repo.nextFailure = const AuthFailure('bad credentials');
      final r1 = await repo.signInWithEmail('a@b.com', 'x');
      expect(r1, isA<Error<AuthUser>>());
      expect((r1 as Error<AuthUser>).failure, isA<AuthFailure>());
      expect(repo.currentUser, isNull);

      final r2 = await repo.signInWithEmail('a@b.com', 'x');
      expect(r2.isSuccess, isTrue);
    });

    test('signOut clears currentUser and emits null', () async {
      repo.emitSignedIn();
      expect(repo.currentUser, isNotNull);

      final emissions = <AuthUser?>[];
      final sub = repo.authStateChanges().listen(emissions.add);

      await repo.signOut();
      await Future<void>.delayed(Duration.zero);

      expect(repo.currentUser, isNull);
      expect(emissions.last, isNull);
      await sub.cancel();
    });
  });
}
