/// Atomic Flutter Supabase Integration
/// Provides atomic-specific enhancements on top of official supabase_flutter package
library atomic_supabase;

// Re-export official supabase_flutter (hiding conflicting AuthState)
export 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;

// Atomic-specific Models
export 'models/supabase_user.dart';
export 'models/supabase_response.dart';
export 'models/supabase_error.dart';

// Atomic-specific Exceptions
export 'exceptions/supabase_exceptions.dart';

// Atomic-specific Authentication Features
export 'auth/supabase_auth_state.dart';
export 'auth/supabase_session_manager.dart';
export 'auth/supabase_auth_middleware.dart';
export 'auth/supabase_auth_helpers.dart';

// Main Atomic Wrapper (Primary Interface)
export 'supabase_atomic_wrapper.dart'; 