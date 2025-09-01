import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth/auth_provider.dart';
import '../constants/atomic_app_constants.dart';

/// Standardized home screen template that provides common layout patterns
/// and functionality used across Flutter applications.
///
/// This template eliminates code duplication by providing:
/// - Consistent app bar with logout functionality
/// - Standardized logout confirmation dialog
/// - Common navigation patterns
/// - Responsive layout structure
/// - Authentication state handling
///
/// Usage:
/// ```dart
/// class HomeScreen extends ConsumerWidget {
///   @override
///   Widget build(BuildContext context, WidgetRef ref) {
///     return AtomicHomeScreenTemplate(
///       appName: AppConstants.appName,
///       primaryColor: Color(AppConstants.primaryColorValue),
///       body: YourCustomContent(),
///       floatingActionButton: YourCustomFAB(), // optional
///     );
///   }
/// }
/// ```
class AtomicHomeScreenTemplate extends ConsumerWidget {
  /// The main content of the home screen
  final Widget body;
  
  /// App name for the app bar title
  final String appName;
  
  /// Primary color for theming
  final Color primaryColor;
  
  /// Debug prefix for logging
  final String? debugPrefix;
  
  /// Custom app bar actions (will be added before logout button)
  final List<Widget>? appBarActions;
  
  /// Custom floating action button
  final Widget? floatingActionButton;
  
  /// Custom bottom navigation bar
  final Widget? bottomNavigationBar;
  
  /// Custom drawer
  final Widget? drawer;
  
  /// Custom end drawer
  final Widget? endDrawer;
  
  /// Whether to show the logout button in app bar
  final bool showLogoutButton;
  
  /// Whether to show logout confirmation dialog
  final bool showLogoutConfirmation;
  
  /// Custom logout callback (overrides default behavior)
  final VoidCallback? onLogout;
  
  /// Custom app bar (completely overrides default app bar)
  final PreferredSizeWidget? customAppBar;
  
  /// Whether to make the body safe area wrapped
  final bool wrapBodyInSafeArea;

  const AtomicHomeScreenTemplate({
    super.key,
    required this.body,
    required this.appName,
    required this.primaryColor,
    this.debugPrefix,
    this.appBarActions,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.drawer,
    this.endDrawer,
    this.showLogoutButton = true,
    this.showLogoutConfirmation = true,
    this.onLogout,
    this.customAppBar,
    this.wrapBodyInSafeArea = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    
    // Debug logging if prefix is provided
    if (debugPrefix != null) {
      debugPrint('$debugPrefix HomeScreen.build: User authenticated: ${authState.isAuthenticated}');
    }

    return Scaffold(
      appBar: customAppBar ?? _buildAppBar(context, ref),
      body: wrapBodyInSafeArea ? SafeArea(child: body) : body,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      drawer: drawer,
      endDrawer: endDrawer,
    );
  }

  /// Build the default app bar with logout functionality
  PreferredSizeWidget _buildAppBar(BuildContext context, WidgetRef ref) {
    return AppBar(
      title: Text(
        appName,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      backgroundColor: primaryColor,
      elevation: 0,
      centerTitle: true,
      iconTheme: const IconThemeData(color: Colors.white),
      actions: [
        // Custom actions first
        if (appBarActions != null) ...appBarActions!,
        
        // Logout button
        if (showLogoutButton) ...[
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: AtomicAppConstants.logout,
            onPressed: () => _handleLogout(context, ref),
          ),
        ],
      ],
    );
  }

  /// Handle logout with optional confirmation dialog
  Future<void> _handleLogout(BuildContext context, WidgetRef ref) async {
    if (debugPrefix != null) {
      debugPrint('$debugPrefix Logout button pressed');
    }

    // Use custom logout callback if provided
    if (onLogout != null) {
      onLogout!();
      return;
    }

    // Show confirmation dialog if enabled
    if (showLogoutConfirmation) {
      final confirmed = await _showLogoutConfirmationDialog(context);
      if (!confirmed) {
        if (debugPrefix != null) {
          debugPrint('$debugPrefix Logout cancelled by user');
        }
        return;
      }
    }

    // Perform logout
    if (debugPrefix != null) {
      debugPrint('$debugPrefix Executing logout...');
    }
    
    try {
      await ref.read(authProvider.notifier).signOut();
      if (debugPrefix != null) {
        debugPrint('$debugPrefix Logout successful');
      }
    } catch (e) {
      if (debugPrefix != null) {
        debugPrint('$debugPrefix Logout failed: $e');
      }
      
      // Show error to user
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Logout failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Show logout confirmation dialog
  Future<bool> _showLogoutConfirmationDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AtomicAppConstants.logout),
        content: const Text(AtomicAppConstants.signOutConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(AtomicAppConstants.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
            ),
            child: const Text(
              AtomicAppConstants.logout,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
    
    return result ?? false;
  }
}

/// Extended home screen template with common sections
class AtomicExtendedHomeScreenTemplate extends ConsumerWidget {
  /// App name for the app bar title
  final String appName;
  
  /// Primary color for theming
  final Color primaryColor;
  
  /// Debug prefix for logging
  final String? debugPrefix;
  
  /// Welcome section content
  final Widget? welcomeSection;
  
  /// Quick actions section
  final Widget? quickActionsSection;
  
  /// Recent items section
  final Widget? recentItemsSection;
  
  /// Custom sections to add at the bottom
  final List<Widget>? additionalSections;
  
  /// Whether to show the user greeting
  final bool showUserGreeting;
  
  /// Custom user greeting text
  final String? customGreeting;

  const AtomicExtendedHomeScreenTemplate({
    super.key,
    required this.appName,
    required this.primaryColor,
    this.debugPrefix,
    this.welcomeSection,
    this.quickActionsSection,
    this.recentItemsSection,
    this.additionalSections,
    this.showUserGreeting = true,
    this.customGreeting,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    
    return AtomicHomeScreenTemplate(
      appName: appName,
      primaryColor: primaryColor,
      debugPrefix: debugPrefix,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User greeting section
            if (showUserGreeting) ...[
              _buildUserGreeting(authState),
              const SizedBox(height: 24),
            ],
            
            // Welcome section
            if (welcomeSection != null) ...[
              welcomeSection!,
              const SizedBox(height: 24),
            ],
            
            // Quick actions section
            if (quickActionsSection != null) ...[
              _buildSectionTitle(context, 'Quick Actions'),
              const SizedBox(height: 12),
              quickActionsSection!,
              const SizedBox(height: 24),
            ],
            
            // Recent items section
            if (recentItemsSection != null) ...[
              _buildSectionTitle(context, 'Recent'),
              const SizedBox(height: 12),
              recentItemsSection!,
              const SizedBox(height: 24),
            ],
            
            // Additional custom sections
            if (additionalSections != null)
              ...additionalSections!.map((section) => Column(
                children: [
                  section,
                  const SizedBox(height: 24),
                ],
              )),
            
            // Bottom padding for better scrolling
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  /// Build user greeting section
  Widget _buildUserGreeting(dynamic authState) {
    final greeting = customGreeting ?? _getTimeBasedGreeting();
    final userName = authState.user?.name ?? 'User';
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primaryColor.withValues(alpha: 0.1),
            primaryColor.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: primaryColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$greeting, $userName!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Welcome to $appName',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  /// Build section title
  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: primaryColor,
      ),
    );
  }

  /// Get time-based greeting
  String _getTimeBasedGreeting() {
    final hour = DateTime.now().hour;
    
    if (hour >= 5 && hour < 12) {
      return 'Good morning';
    } else if (hour >= 12 && hour < 17) {
      return 'Good afternoon';
    } else {
      return 'Good evening';
    }
  }
}