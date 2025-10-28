class AppException implements Exception {
  final String message;
  final String? details;

  AppException(this.message, {this.details});

  @override
  String toString() => 'AppException: $message';
}

/// Exceção para erros de rede (requisições, API offline etc.)
class NetworkException extends AppException {
  NetworkException(String message, {String? details})
      : super(message, details: details);
}

/// Exceção para falhas de autenticação ou login inválido
class AuthException extends AppException {
  AuthException(String message, {String? details})
      : super(message, details: details);
}

/// Exceção para problemas de permissão (GPS, câmera, armazenamento)
class PermissionException extends AppException {
  PermissionException(String message, {String? details})
      : super(message, details: details);
}

/// Exceção genérica para falhas inesperadas
class UnknownException extends AppException {
  UnknownException(String message, {String? details})
      : super(message, details: details);
}
