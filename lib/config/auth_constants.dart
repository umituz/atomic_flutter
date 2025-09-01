/// Shared authentication constants for all Flutter apps using atomic_flutter_kit.
/// 
/// This file provides centralized test credentials and auth-related constants
/// to ensure consistency across all applications in the ecosystem.
class AtomicAuthConstants {
  /// Test user credentials for development and testing
  static const String testUserEmail = 'user@test.com';
  static const String testUserPassword = 'user123';
  
  /// Test admin credentials for development and testing
  static const String testAdminEmail = 'admin@test.com';
  static const String testAdminPassword = 'admin123';
  
  /// Default password visibility for testing (false = visible)
  static const bool defaultPasswordObscured = false;
  
  /// Auth form validation messages
  static const String emailRequiredError = 'Please enter your email address';
  static const String passwordRequiredError = 'Please enter your password';
  static const String nameRequiredError = 'Please enter your full name';
  static const String invalidEmailError = 'Please enter a valid email address';
  static const String passwordMinLengthError = 'Password must be at least 6 characters';
  static const String passwordMismatchError = 'Passwords do not match';
  
  /// Auth screen text constants
  static const String welcomeBackTitle = 'Welcome Back';
  static const String signInSubtitle = 'Sign in to continue your journey';
  static const String createAccountTitle = 'Join Us';
  static const String signUpSubtitle = 'Create your account and start exploring';
  
  /// Button text constants
  static const String signInButtonText = 'Sign In';
  static const String signUpButtonText = 'Create Account';
  static const String forgotPasswordText = 'Forgot Password?';
  static const String rememberMeText = 'Remember Me';
  
  /// Navigation text constants
  static const String noAccountQuestion = "Don't have an account? ";
  static const String alreadyHaveAccountQuestion = "Already have an account? ";
  static const String signUpLinkText = 'Sign Up';
  static const String signInLinkText = 'Sign In';
  
  /// Hint text constants
  static const String enterEmailHint = 'Enter your email';
  static const String enterPasswordHint = 'Enter your password';
  static const String enterNameHint = 'Enter your full name';
  static const String createPasswordHint = 'Create a password';
  static const String confirmPasswordHint = 'Confirm your password';
  
  /// Terms and conditions
  static const String termsAcceptanceText = 'I accept the Terms and Conditions';
  static const String termsComingSoonMessage = 'Terms and conditions coming soon!';
  
  /// Success messages
  static const String loginSuccessMessage = 'Welcome back!';
  static const String registrationSuccessMessage = 'Account created successfully!';
  static const String logoutSuccessMessage = 'Logged out successfully';
  
  /// Error messages
  static const String networkErrorMessage = 'Network connection failed. Please try again.';
  static const String serverErrorMessage = 'Server error occurred. Please try again later.';
  static const String invalidCredentialsMessage = 'Invalid email or password';
  static const String sessionExpiredMessage = 'Your session has expired. Please sign in again.';
  static const String unknownErrorMessage = 'An unexpected error occurred. Please try again.';
}