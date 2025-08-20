library atomic_supabase;

export 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;

export 'models/supabase_user.dart';
export 'models/supabase_response.dart';
export 'models/supabase_error.dart';

export 'exceptions/supabase_exceptions.dart';

export 'auth/supabase_auth_state.dart';
export 'auth/supabase_session_manager.dart';
export 'auth/supabase_auth_middleware.dart';
export 'auth/supabase_auth_helpers.dart';

export 'database/atomic_database_service.dart';
export 'database/atomic_caching_service.dart';

export 'supabase_atomic_wrapper.dart'; 