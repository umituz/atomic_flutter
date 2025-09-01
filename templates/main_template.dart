import 'package:flutter/material.dart';
import 'package:atomic_flutter_kit/atomic_flutter_kit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'core/router/app_router.dart'; // TODO: Replace with your project's router
// import 'core/constants/app_constants.dart'; // TODO: Replace with your project's constants

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  try {
    await dotenv.load(fileName: ".env");
    debugPrint('[APP] Environment loaded successfully'); // TODO: Replace with AppConstants.debugPrefix
  } catch (e) {
    debugPrint('[APP] Environment load failed: $e'); // TODO: Replace with AppConstants.debugPrefix
    // Don't rethrow - app can still work with defaults
  }

  // 🚨 CRITICAL: Initialize Auth Service with ApiConfig
  final apiBaseUrl = dotenv.env['API_BASE_URL'] ?? 'https://api.example.com'; // TODO: Replace with ApiConfig.defaultBaseUrl
  AuthService.instance.initialize(apiBaseUrl);
  
  // 🚨 CRITICAL: Initialize HTTP Client
  AtomicHttpClient.instance.initialize(
    baseUrl: apiBaseUrl,
    enableLogging: true,
  );

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Create custom theme for app
    final appTheme = AtomicThemeData(
      name: 'MyAppTheme', // TODO: Replace with AppConstants.appName
      colors: AtomicColorScheme.defaultScheme.copyWith(
        primary: const Color(0xFF2196F3), // TODO: Replace with AppConstants.primaryColorValue
        secondary: const Color(0xFF03DAC6), // TODO: Replace with AppConstants.secondaryColorValue
        accent: const Color(0xFFFF5722), // TODO: Replace with AppConstants.accentColorValue
      ),
    );

    return AtomicThemeProvider(
      theme: appTheme,
      child: MaterialApp.router(
        title: 'My App', // TODO: Replace with AppConstants.appName
        debugShowCheckedModeBanner: false,
        theme: appTheme.toMaterialTheme(),
        routerConfig: null, // TODO: Replace with appRouter
      ),
    );
  }
}