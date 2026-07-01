// test/core/error/result_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:travelconnect/core/error/failure.dart';
import 'package:travelconnect/core/error/result.dart';

void main() {
  group('Result', () {
    test('Success holds a value and isSuccess is true', () {
      const result = Success<int>(42);
      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull, 42);
    });

    test('Error holds a failure and isSuccess is false', () {
      const result = Error<int>(ServerFailure('boom'));
      expect(result.isSuccess, isFalse);
      expect(result.valueOrNull, isNull);
      expect((result as Error<int>).failure.message, 'boom');
    });
  });
}
