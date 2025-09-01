/// 🔐 API Configuration for Atomic Flutter Kit
/// 
/// Centralized API configuration used by all Flutter apps.
/// This configuration is shared across all apps using atomic_flutter_kit package.
class ApiConfig {
  // API Base Configuration
  static const String defaultBaseUrl = 'http://localhost:8080';
  static const String tokenKey = 'auth_token';
  static const String userUuidKey = 'user_uuid';
  static const String refreshTokenKey = 'refresh_token';
  
  // Authentication Endpoints
  static const String loginEndpoint = '/api/login';
  static const String registerEndpoint = '/api/register';
  static const String logoutEndpoint = '/api/logout';
  static const String refreshEndpoint = '/api/refresh';
  static const String userProfileEndpoint = '/api/profile';
  
  // Module Endpoints Patterns
  static String randomActivityEndpoint(String path) => '/api/randomactivity/$path';
  static String meditationTimerEndpoint(String path) => '/api/meditationtimer/$path';
  static String workoutPlannerEndpoint(String path) => '/api/workoutplanner/$path';
  static String jokeGeneratorEndpoint(String path) => '/api/jokegenerator/$path';
  
  // HTTP Headers
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
}

/// 🔐 Authentication Messages
class AuthMessages {
  // Success Messages
  static const String loginSuccess = 'Login successful';
  static const String registerSuccess = 'Registration successful';
  static const String logoutSuccess = 'Logged out successfully';
  
  // Error Messages
  static const String invalidCredentials = 'Invalid email or password';
  static const String networkError = 'Network connection failed';
  static const String serverError = 'Server error occurred';
  static const String sessionExpired = 'Session has expired';
  static const String unknownError = 'An unknown error occurred';
  static const String emailInUse = 'Email is already in use';
  static const String weakPassword = 'Password is too weak';
  static const String invalidEmail = 'Invalid email format';
}

/// 🔐 Test User Credentials
class TestUsers {
  static const String userEmail = 'user@test.com';
  static const String userPassword = 'user123';
  
  static const String adminEmail = 'admin@test.com';
  static const String adminPassword = 'admin123';
}