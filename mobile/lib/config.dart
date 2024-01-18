class Config {
  static const bool apiIsHttps = bool.fromEnvironment('API_IS_HTTPS', defaultValue: true);
  static const String apiHost = String.fromEnvironment('API_HOST', defaultValue: 'solutrain-backend.onrender.com');
  static const int apiPort = int.fromEnvironment('API_PORT', defaultValue: 80);
}
