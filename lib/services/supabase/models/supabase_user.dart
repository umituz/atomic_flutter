/// Supabase User Model
/// Represents a user in the Supabase system

class SupabaseUser {
  const SupabaseUser({
    required this.id,
    required this.email,
    this.phone,
    this.emailConfirmedAt,
    this.phoneConfirmedAt,
    this.lastSignInAt,
    this.role,
    this.createdAt,
    this.updatedAt,
    this.userMetadata,
    this.appMetadata,
    this.identities,
  });

  /// User ID (UUID)
  final String id;
  
  /// User email
  final String email;
  
  /// User phone number
  final String? phone;
  
  /// Email confirmation timestamp
  final DateTime? emailConfirmedAt;
  
  /// Phone confirmation timestamp
  final DateTime? phoneConfirmedAt;
  
  /// Last sign in timestamp
  final DateTime? lastSignInAt;
  
  /// User role
  final String? role;
  
  /// Account creation timestamp
  final DateTime? createdAt;
  
  /// Last update timestamp
  final DateTime? updatedAt;
  
  /// User metadata (editable by user)
  final Map<String, dynamic>? userMetadata;
  
  /// App metadata (controlled by app)
  final Map<String, dynamic>? appMetadata;
  
  /// User identities (providers)
  final List<SupabaseUserIdentity>? identities;

  /// Create from official Supabase User
  factory SupabaseUser.fromSupabaseUser(dynamic user) {
    return SupabaseUser(
      id: user.id,
      email: user.email,
      phone: user.phone,
      emailConfirmedAt: user.emailConfirmedAt,
      phoneConfirmedAt: user.phoneConfirmedAt,
      lastSignInAt: user.lastSignInAt,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
      userMetadata: user.userMetadata,
      appMetadata: user.appMetadata,
      identities: user.identities?.map((identity) => SupabaseUserIdentity.fromJson(identity.toJson())).toList() ?? [],
    );
  }

  /// Create from JSON
  factory SupabaseUser.fromJson(Map<String, dynamic> json) {
    return SupabaseUser(
      id: json['id'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      emailConfirmedAt: json['email_confirmed_at'] != null
          ? DateTime.parse(json['email_confirmed_at'] as String)
          : null,
      phoneConfirmedAt: json['phone_confirmed_at'] != null
          ? DateTime.parse(json['phone_confirmed_at'] as String)
          : null,
      lastSignInAt: json['last_sign_in_at'] != null
          ? DateTime.parse(json['last_sign_in_at'] as String)
          : null,
      role: json['role'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      userMetadata: json['user_metadata'] as Map<String, dynamic>?,
      appMetadata: json['app_metadata'] as Map<String, dynamic>?,
      identities: (json['identities'] as List<dynamic>?)
          ?.map((i) => SupabaseUserIdentity.fromJson(i as Map<String, dynamic>))
          .toList(),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'phone': phone,
      'email_confirmed_at': emailConfirmedAt?.toIso8601String(),
      'phone_confirmed_at': phoneConfirmedAt?.toIso8601String(),
      'last_sign_in_at': lastSignInAt?.toIso8601String(),
      'role': role,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'user_metadata': userMetadata,
      'app_metadata': appMetadata,
      'identities': identities?.map((i) => i.toJson()).toList(),
    };
  }

  /// Copy with new values
  SupabaseUser copyWith({
    String? id,
    String? email,
    String? phone,
    DateTime? emailConfirmedAt,
    DateTime? phoneConfirmedAt,
    DateTime? lastSignInAt,
    String? role,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? userMetadata,
    Map<String, dynamic>? appMetadata,
    List<SupabaseUserIdentity>? identities,
  }) {
    return SupabaseUser(
      id: id ?? this.id,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      emailConfirmedAt: emailConfirmedAt ?? this.emailConfirmedAt,
      phoneConfirmedAt: phoneConfirmedAt ?? this.phoneConfirmedAt,
      lastSignInAt: lastSignInAt ?? this.lastSignInAt,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      userMetadata: userMetadata ?? this.userMetadata,
      appMetadata: appMetadata ?? this.appMetadata,
      identities: identities ?? this.identities,
    );
  }

  /// Check if email is confirmed
  bool get isEmailConfirmed => emailConfirmedAt != null;

  /// Check if phone is confirmed
  bool get isPhoneConfirmed => phoneConfirmedAt != null;

  /// Get display name from metadata or email
  String get displayName {
    if (userMetadata?['full_name'] != null) {
      return userMetadata!['full_name'] as String;
    }
    if (userMetadata?['name'] != null) {
      return userMetadata!['name'] as String;
    }
    if (userMetadata?['display_name'] != null) {
      return userMetadata!['display_name'] as String;
    }
    return email.split('@').first;
  }

  /// Get avatar URL from metadata
  String? get avatarUrl {
    return userMetadata?['avatar_url'] as String?;
  }

  /// Get provider list
  List<String> get providers {
    return identities?.map((i) => i.provider).toList() ?? [];
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SupabaseUser && other.id == id && other.email == email;
  }

  @override
  int get hashCode => Object.hash(id, email);

  @override
  String toString() => 'SupabaseUser(id: $id, email: $email)';
}

/// User Identity (OAuth provider info)
class SupabaseUserIdentity {
  const SupabaseUserIdentity({
    required this.id,
    required this.userId,
    required this.provider,
    required this.identityData,
    this.lastSignInAt,
    this.createdAt,
    this.updatedAt,
  });

  /// Identity ID
  final String id;
  
  /// User ID this identity belongs to
  final String userId;
  
  /// Provider name (email, google, github, etc.)
  final String provider;
  
  /// Identity data from provider
  final Map<String, dynamic> identityData;
  
  /// Last sign in with this identity
  final DateTime? lastSignInAt;
  
  /// Identity creation timestamp
  final DateTime? createdAt;
  
  /// Last update timestamp
  final DateTime? updatedAt;

  /// Create from JSON
  factory SupabaseUserIdentity.fromJson(Map<String, dynamic> json) {
    return SupabaseUserIdentity(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      provider: json['provider'] as String,
      identityData: json['identity_data'] as Map<String, dynamic>,
      lastSignInAt: json['last_sign_in_at'] != null
          ? DateTime.parse(json['last_sign_in_at'] as String)
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'provider': provider,
      'identity_data': identityData,
      'last_sign_in_at': lastSignInAt?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  @override
  String toString() => 'SupabaseUserIdentity(provider: $provider, id: $id)';
} 