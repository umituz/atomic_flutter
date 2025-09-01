/// Abstract base class for standardized app constants across Flutter applications.
///
/// This class provides common constants that are identical across all apps,
/// while allowing app-specific customization through inheritance.
///
/// Usage:
/// ```dart
/// class AppConstants extends AtomicAppConstants {
///   @override
///   static String get appName => 'My Amazing App';
///   
///   @override
///   static String get tagline => 'Amazing features await!';
///   
///   @override
///   static int get primaryColorValue => 0xFF6366F1;
/// }
/// ```
abstract class AtomicAppConstants {
  // =================================================================
  // APP IDENTITY - Must be overridden by implementing classes
  // =================================================================
  
  /// The display name of the application
  static String get appName => throw UnimplementedError('appName must be implemented');
  
  /// App tagline or subtitle
  static String get tagline => throw UnimplementedError('tagline must be implemented');
  
  /// Primary color value as int (for atomic_flutter_kit compatibility)
  static int get primaryColorValue => throw UnimplementedError('primaryColorValue must be implemented');
  
  /// Secondary color value as int
  static int get secondaryColorValue => throw UnimplementedError('secondaryColorValue must be implemented');
  
  /// Accent color value as int
  static int get accentColorValue => throw UnimplementedError('accentColorValue must be implemented');
  
  // =================================================================
  // CONST COLOR VALUES - Must be overridden by implementing classes for const expressions
  // =================================================================
  
  /// Primary color value as const int (for const expressions)
  /// This should match the value returned by primaryColorValue getter
  static const int constPrimaryColorValue = 0xFF000000; // Placeholder - must be overridden
  
  /// Secondary color value as const int (for const expressions)
  /// This should match the value returned by secondaryColorValue getter
  static const int constSecondaryColorValue = 0xFF000000; // Placeholder - must be overridden
  
  /// Accent color value as const int (for const expressions)
  /// This should match the value returned by accentColorValue getter
  static const int constAccentColorValue = 0xFF000000; // Placeholder - must be overridden
  
  // =================================================================
  // COMPUTED PROPERTIES - Automatically generated from overrides
  // =================================================================
  
  /// Debug prefix for logging - automatically generated from app name
  static String get debugPrefix => '[${appName.replaceAll(' ', '').replaceAll(RegExp(r'[^a-zA-Z0-9]'), '')}]';
  
  /// Welcome title with app name
  static String get welcomeTitle => 'Welcome to $appName!';
  
  /// Join app title with app name
  static String get joinAppTitle => 'Join $appName';
  
  /// Welcome back title for login
  static String get welcomeBackTitle => 'Welcome Back';
  
  /// Create account title for registration
  static String get createAccountTitle => 'Create Account';
  
  /// Registration tagline
  static String get registrationTagline => 'Create your account to get personalized suggestions';
  
  /// Create account subtitle
  static String get createAccountSubtitle => 'Fill in the details below to create your account';
  
  // =================================================================
  // STANDARDIZED CONSTANTS - Same across all apps (no override needed)
  // =================================================================
  
  // App Info
  static const String appVersion = '1.0.0';
  
  // Routes
  static const String loginRoute = '/auth';
  static const String homeRoute = '/';
  static const String favoritesRoute = '/favorites';
  static const String historyRoute = '/history';
  static const String preferencesRoute = '/preferences';
  static const String settingsRoute = '/settings';
  static const String profileRoute = '/profile';
  
  // Authentication Text
  static const String completionCelebration = 'Great job! 🎉';
  
  // Form Labels
  static const String emailAddressLabel = 'Email Address';
  static const String passwordLabel = 'Password';
  static const String fullNameLabel = 'Full Name';
  static const String confirmPasswordLabel = 'Confirm Password';
  static const String nameLabel = 'Name';
  static const String emailLabel = 'Email';
  
  // Form Hints
  static const String enterEmailHint = 'Enter your email';
  static const String enterPasswordHint = 'Enter your password';
  static const String enterNameHint = 'Enter your full name';
  static const String createPasswordHint = 'Create a strong password';
  static const String confirmPasswordHint = 'Confirm your password';
  
  // Form Descriptions
  static const String verificationCodeSubtitle = 'Enter your email to receive a verification code';
  static const String termsAgreement = 'By creating an account, you agree to our\nTerms of Service and Privacy Policy';
  
  // Validation Messages
  static const String emailRequiredError = 'Please enter your email address';
  static const String invalidEmailError = 'Please enter a valid email address';
  static const String passwordRequiredError = 'Please enter your password';
  static const String passwordMinLengthError = 'Password must be at least 6 characters';
  static const String nameRequiredError = 'Please enter your full name';
  static const String nameMinLengthError = 'Name must be at least 2 characters';
  static const String passwordComplexityError = 'Password must contain uppercase, lowercase and numbers';
  static const String passwordMismatchError = 'Passwords do not match';
  
  // Dialog Content
  static const String signOutConfirmation = 'Are you sure you want to sign out?';
  static const String clearHistoryConfirmation = 'Are you sure you want to clear all history?';
  static const String deleteConfirmation = 'Are you sure you want to delete this item?';
  
  // Questions & Links
  static const String noAccountQuestion = "Don't have an account?";
  static const String alreadyHaveAccountQuestion = 'Already have an account?';
  
  // General UI Actions
  static const String loading = 'Loading';
  static const String error = 'Error';
  static const String success = 'Success';
  static const String cancel = 'Cancel';
  static const String confirm = 'Confirm';
  static const String retry = 'Retry';
  static const String close = 'Close';
  static const String save = 'Save';
  static const String delete = 'Delete';
  static const String edit = 'Edit';
  static const String add = 'Add';
  static const String done = 'Done';
  static const String next = 'Next';
  static const String previous = 'Previous';
  static const String back = 'Back';
  static const String skip = 'Skip';
  static const String settings = 'Settings';
  static const String profile = 'Profile';
  static const String logout = 'Logout';
  static const String welcome = 'Welcome';
  
  // Auth Buttons & Labels
  static const String signIn = 'Sign In';
  static const String signUp = 'Sign Up';
  static const String email = 'Email';
  static const String password = 'Password';
  static const String confirmPassword = 'Confirm Password';
  static const String forgotPassword = 'Forgot Password?';
  static const String resetPassword = 'Reset Password';
  static const String signInWithGoogle = 'Sign in with Google';
  static const String signInWithApple = 'Sign in with Apple';
  static const String signInSuccess = 'Signed in successfully';
  static const String signUpSuccess = 'Account created successfully';
  static const String signOutSuccess = 'Signed out successfully';
  static const String authError = 'Authentication failed';
  static const String invalidCredentials = 'Invalid email or password';
  
  // Settings & Preferences
  static const String appearance = 'Appearance';
  static const String darkMode = 'Dark Mode';
  static const String lightMode = 'Light Mode';
  static const String systemTheme = 'System Theme';
  static const String language = 'Language';
  static const String notifications = 'Notifications';
  static const String aboutApp = 'About App';
  static const String version = 'Version';
  static const String privacyPolicy = 'Privacy Policy';
  static const String termsOfService = 'Terms of Service';
  static const String contactUs = 'Contact Us';
  static const String rateApp = 'Rate App';
  static const String shareApp = 'Share App';
  static const String feedback = 'Feedback';
  
  // Error Messages
  static const String genericError = 'Something went wrong. Please try again.';
  static const String networkError = 'Network error. Please check your connection.';
  static const String serverError = 'Server error. Please try again later.';
  static const String timeoutError = 'Request timeout. Please try again.';
  static const String unexpectedError = 'An unexpected error occurred';
  static const String noInternetConnection = 'No internet connection';
  static const String failedToLoadData = 'Failed to load data';
  static const String failedToSaveData = 'Failed to save data';
  static const String pleaseWait = 'Please wait...';
  
  // Database Messages
  static const String userCreated = 'User created successfully';
  static const String userUpdated = 'User updated successfully';
  static const String userNotFound = 'User not found';
  static const String dataLoadFailed = 'Failed to load data';
  static const String dataSaveFailed = 'Failed to save data';
  static const String connectionFailed = 'Connection failed';
  
  // Color Values - Common colors for apps that don't want to customize
  static const int successColorValue = 0xFF10B981;
  static const int warningColorValue = 0xFFF59E0B;
  static const int errorColorValue = 0xFFEF4444;
  static const int infoColorValue = 0xFF3B82F6;
  
  // Storage Keys - Standardized prefix pattern
  static String get storagePrefix => '${appName.toLowerCase().replaceAll(' ', '_')}_';
  static String get userPreferencesKey => '${storagePrefix}user_preferences';
  static String get historyKey => '${storagePrefix}history';
  static String get favoritesKey => '${storagePrefix}favorites';
  static String get themeKey => '${storagePrefix}theme';
  static String get languageKey => '${storagePrefix}language';
  static String get notificationsKey => '${storagePrefix}notifications';
  
  // API Configuration Keys
  static const String tokenKey = 'auth_token';
  static const String userUuidKey = 'user_uuid';
  static const String refreshTokenKey = 'refresh_token';
  
  // Pagination
  static const int defaultPageSize = 15;
  static const int maxItemsPerPage = 100;
  
  // Validation Limits
  static const int maxTitleLength = 255;
  static const int maxDescriptionLength = 1000;
  static const int maxNotesLength = 500;
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 128;
}

