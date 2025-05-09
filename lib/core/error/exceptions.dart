class ServerException implements Exception {
  final String? message;
  ServerException([this.message]);
}

class NetworkException implements Exception {
  final String? message;
  NetworkException([this.message]);
}

class BadRequestException implements Exception {
  final String? message;
  BadRequestException([this.message]);
}

class UnauthorisedException implements Exception {
  final String? message;
  UnauthorisedException([this.message]);
}

class NotFoundException implements Exception {
  final String message;

  NotFoundException([this.message = 'Not Found']);

  @override
  String toString() => message;
}

class FetchDataException implements Exception {
  final String? message;
  FetchDataException([this.message]);
}

class InvalidCredentialException implements Exception {
  final String? message;
  InvalidCredentialException([this.message]);
}
