import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../services/auth/auth_service.dart';
import '../../services/http/atomic_http_client.dart';
import '../../config/api_config.dart';

/// Standardized app initialization helper that handles common setup tasks
/// across all Flutter applications using atomic_flutter_kit.
///
/// This class eliminates code duplication by providing a unified initialization
/// pattern for environment loading, service initialization, and framework setup.
///
/// Usage:
/// ```dart
/// void main() async {
///   await AtomicAppInitializer.initialize(
///     debugPrefix: AppConstants.debugPrefix,
///   );
///   
///   runApp(const ProviderScope(child: MyApp()));
/// }
/// ```
class AtomicAppInitializer {
  /// Initialize the Flutter application with standardized setup.
  ///
  /// This method performs the following initialization steps:
  /// 1. Ensures Flutter widgets binding is initialized
  /// 2. Loads environment variables from .env file
  /// 3. Initializes authentication service
  /// 4. Initializes HTTP client service
  /// 5. Provides comprehensive logging for debugging
  ///
  /// Parameters:
  /// - [debugPrefix]: App-specific debug prefix for logging (e.g., '[MyApp]')
  /// - [envFileName]: Environment file name (defaults to '.env')
  /// - [enableHttpLogging]: Enable HTTP request/response logging (defaults to true in debug mode)
  /// - [customApiBaseUrl]: Override API base URL (optional, uses .env if not provided)
  /// - [additionalSetup]: Custom initialization callback for app-specific setup
  static Future<void> initialize({
    required String debugPrefix,
    String envFileName = '.env',
    bool? enableHttpLogging,
    String? customApiBaseUrl,
    Future<void> Function()? additionalSetup,
  }) async {
    // Step 1: Initialize Flutter widgets binding
    WidgetsFlutterBinding.ensureInitialized();
    debugPrint('$debugPrefix Flutter widgets binding initialized');

    // Step 2: Load environment variables
    await _loadEnvironment(envFileName, debugPrefix);
    
    // Step 3: Initialize core services
    await _initializeServices(
      debugPrefix,
      enableHttpLogging ?? kDebugMode,
      customApiBaseUrl,
    );
    
    // Step 4: Execute custom app-specific setup if provided
    if (additionalSetup != null) {
      debugPrint('$debugPrefix Executing custom setup...');
      try {
        await additionalSetup();
        debugPrint('$debugPrefix Custom setup completed successfully');
      } catch (e, stackTrace) {
        debugPrint('$debugPrefix Custom setup failed: $e');
        if (kDebugMode) {
          debugPrint('$debugPrefix Stack trace: $stackTrace');
        }
        rethrow;
      }
    }
    
    debugPrint('$debugPrefix Application initialization completed successfully');
  }

  /// Load environment variables from the specified file
  static Future<void> _loadEnvironment(String fileName, String debugPrefix) async {
    try {
      await dotenv.load(fileName: fileName);
      debugPrint('$debugPrefix Environment loaded successfully from $fileName');
      
      // Log important environment variables (without exposing sensitive data)
      final apiBaseUrl = dotenv.env['API_BASE_URL'];
      if (apiBaseUrl != null) {
        debugPrint('$debugPrefix API Base URL: $apiBaseUrl');
      } else {
        debugPrint('$debugPrefix Warning: API_BASE_URL not found in environment');
      }
      
    } catch (e) {
      debugPrint('$debugPrefix Environment load failed: $e');
      debugPrint('$debugPrefix Continuing with default configuration...');
      
      // Don't throw - allow app to continue with defaults
      // Most apps should still work without .env file
    }
  }

  /// Initialize core services (Auth and HTTP Client)
  static Future<void> _initializeServices(
    String debugPrefix,
    bool enableHttpLogging,
    String? customApiBaseUrl,
  ) async {
    try {
      // Determine API base URL
      final apiBaseUrl = customApiBaseUrl ?? 
                        dotenv.env['API_BASE_URL'] ?? 
                        ApiConfig.defaultBaseUrl;
      
      debugPrint('$debugPrefix Initializing services with base URL: $apiBaseUrl');
      
      // Initialize Auth Service
      debugPrint('$debugPrefix Initializing Auth Service...');
      AuthService.instance.initialize(apiBaseUrl);
      debugPrint('$debugPrefix Auth Service initialized successfully');
      
      // Initialize HTTP Client
      debugPrint('$debugPrefix Initializing HTTP Client...');
      AtomicHttpClient.instance.initialize(
        baseUrl: apiBaseUrl,
        enableLogging: enableHttpLogging,
      );
      debugPrint('$debugPrefix HTTP Client initialized successfully');
      
      // Log initialization success
      debugPrint('$debugPrefix All core services initialized successfully');
      
    } catch (e, stackTrace) {
      debugPrint('$debugPrefix Critical error during service initialization: $e');
      if (kDebugMode) {
        debugPrint('$debugPrefix Stack trace: $stackTrace');
      }
      
      // This is critical - if services fail to initialize, the app likely won't work
      rethrow;
    }
  }

  /// Validate environment configuration and log warnings for missing variables
  static void validateEnvironment(String debugPrefix) {
    debugPrint('$debugPrefix Validating environment configuration...');
    
    final requiredVars = ['API_BASE_URL'];
    final optionalVars = ['SUPABASE_URL', 'SUPABASE_ANON_KEY'];
    
    // Check required variables
    for (final varName in requiredVars) {
      final value = dotenv.env[varName];
      if (value == null || value.isEmpty) {
        debugPrint('$debugPrefix WARNING: Required environment variable $varName is missing');
      } else {
        debugPrint('$debugPrefix ✓ $varName is configured');
      }
    }
    
    // Check optional variables
    for (final varName in optionalVars) {
      final value = dotenv.env[varName];
      if (value == null || value.isEmpty) {
        debugPrint('$debugPrefix INFO: Optional environment variable $varName is not set');
      } else {
        debugPrint('$debugPrefix ✓ $varName is configured');
      }
    }
    
    debugPrint('$debugPrefix Environment validation completed');
  }

  /// Get configuration summary for debugging
  static Map<String, dynamic> getConfigurationSummary() {
    return {
      'api_base_url': dotenv.env['API_BASE_URL'] ?? 'Not set',
      'supabase_configured': dotenv.env['SUPABASE_URL'] != null,
      'debug_mode': kDebugMode,
      'environment_loaded': dotenv.env.isNotEmpty,
    };
  }

  /// Initialize with commonly used presets for different app types
  
  /// Preset for simple apps with basic auth and API functionality
  static Future<void> initializeBasicApp({
    required String debugPrefix,
    Future<void> Function()? customSetup,
  }) async {
    await initialize(
      debugPrefix: debugPrefix,
      envFileName: '.env',
      enableHttpLogging: kDebugMode,
      additionalSetup: customSetup,
    );
  }

  /// Preset for production apps with enhanced error handling
  static Future<void> initializeProductionApp({
    required String debugPrefix,
    required String apiBaseUrl,
    Future<void> Function()? customSetup,
  }) async {
    await initialize(
      debugPrefix: debugPrefix,
      envFileName: '.env.production',
      enableHttpLogging: false,
      customApiBaseUrl: apiBaseUrl,
      additionalSetup: customSetup,
    );
  }

  /// Preset for development apps with full logging
  static Future<void> initializeDevelopmentApp({
    required String debugPrefix,
    Future<void> Function()? customSetup,
  }) async {
    await initialize(
      debugPrefix: debugPrefix,
      envFileName: '.env.development',
      enableHttpLogging: true,
      additionalSetup: () async {
        validateEnvironment(debugPrefix);
        if (customSetup != null) {
          await customSetup();
        }
      },
    );
  }
}