/// Sealed class help to prevent the class from being extended by other classes from outside this file
/// This class is used to represent all the possible stated of the result from the API calls
/// The generic type T is helpful to handle any type of the data that is returned from the API
sealed class Result<T> {
  const Result();

  /// Create the factory cosntructor to prevent the user from knowing about the internal implementation
  /// of the [Ok] class
  /// It help to access the value and statusCode from the [Ok] class
  /// The factory constructor doesn't necessarily create a new instance of the class
  const factory Result.ok(String value, int statusCode) = Ok._;


  /// The sealed class prevents creating the subclass instance directly out side from this file
  /// It encapsulates the internal implementation of the [Error] class
  const factory Result.error(T message) = Error._;


}

/// final class helps to prevent the class from being extended by other classes
/// so the inheritence is not possible by other class even in the same file
/// it maintains the hierarchy of this sealed class
/// The order parameter of the Result<> generic class order must be same in its subclasses
final class Ok<T> extends Result<T> {
  /// This is the private constructor that is used to create the instance of the [Ok] class within the same
  /// file and prevents creating instance of this class from outside the file
  const Ok._(this.value, this.statusCode);

  final String value;
  final int statusCode;
}

final class Error<T> extends Result<T> {
  const Error._(this.message);

  final T message;
}

final class NotOk<T> extends Result<T> {
  const NotOk._({required this.message, this.statusCode = 300});

  final T message;
  final int statusCode;
}

