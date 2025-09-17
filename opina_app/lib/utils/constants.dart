class Constants {
  /// URL base del backend, fija en build (compile-time).
  /// Cambia su valor al correr con: --dart-define=BACKEND_BASE=<url>
  static const String apiBaseUrl = String.fromEnvironment(
    'BACKEND_BASE',
    // Por defecto: localhost (ideal para PC / Web)
    defaultValue: 'http://localhost:3000',
  );
}
