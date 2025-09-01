import 'package:flutter/material.dart';
import 'package:atomic_flutter_kit/atomic_flutter_kit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/router/app_router.dart';
import 'core/constants/app_constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  try {
    await dotenv.load(fileName: ".env");
    debugPrint('${AppConstants.debugPrefix} Environment loaded successfully');
  } catch (e) {
    debugPrint('${AppConstants.debugPrefix} Environment load failed: $e');
    // Don't rethrow - app can still work with defaults
  }

  // 🚨 CRITICAL: Initialize Auth Service with ApiConfig
  final apiBaseUrl = dotenv.env['API_BASE_URL'] ?? ApiConfig.defaultBaseUrl;
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
      name: '${AppConstants.appName}Theme',
      colors: AtomicColorScheme.defaultScheme.copyWith(
        primary: Color(AppConstants.primaryColorValue),
        secondary: Color(AppConstants.secondaryColorValue),
        accent: Color(AppConstants.accentColorValue),
      ),
    );

    return AtomicThemeProvider(
      theme: appTheme,
      child: MaterialApp.router(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: appTheme.toMaterialTheme(),
        routerConfig: appRouter,
      ),
    );
  }
}