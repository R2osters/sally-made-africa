// lib/core/error/result.dart
import 'failure.dart';

sealed class Result<T> {
  const Result();

  bool get isSuccess => this is Success<T>;

  T? get valueOrNull => switch (this) {
        Success<T>(value: final v) => v,
        Error<T>() => null,
      };
}

class Success<T> extends Result<T> {
  final T value;
  const Success(this.value);
}

class Error<T> extends Result<T> {
  final Failure failure;
  const Error(this.failure);
}
