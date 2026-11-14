/// Base class which is used to check if an Exception is a custom exception
sealed class UniversalPhotosErrors {
  const UniversalPhotosErrors();
}

class NoResponseDtoError extends UniversalPhotosErrors implements Exception {
  const NoResponseDtoError();

  @override
  String toString() => "Response Dto is null";
}
