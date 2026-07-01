// test/core/config/env_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:travelconnect/core/config/env.dart';

void main() {
  test('Env falls back to placeholder values when dart-define not set', () {
    expect(Env.supabaseUrl, isNotEmpty);
    expect(Env.supabaseAnonKey, isNotEmpty);
  });
}
