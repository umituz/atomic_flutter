/// Atomic Gender Enum
/// Represents gender options with inclusive choices
enum AtomicGender {
  /// Male
  male,
  
  /// Female
  female,
  
  /// Non-binary
  nonBinary,
  
  /// Prefer not to say
  preferNotToSay,
  
  /// Other
  other;

  /// Check if male
  bool get isMale => this == male;

  /// Check if female
  bool get isFemale => this == female;

  /// Check if non-binary
  bool get isNonBinary => this == nonBinary;

  /// Check if prefer not to say
  bool get isPreferNotToSay => this == preferNotToSay;

  /// Check if other
  bool get isOther => this == other;

  /// Get display text for the gender
  String get displayText {
    switch (this) {
      case male:
        return 'Male';
      case female:
        return 'Female';
      case nonBinary:
        return 'Non-binary';
      case preferNotToSay:
        return 'Prefer not to say';
      case other:
        return 'Other';
    }
  }

  /// Get short display text for the gender
  String get shortText {
    switch (this) {
      case male:
        return 'M';
      case female:
        return 'F';
      case nonBinary:
        return 'NB';
      case preferNotToSay:
        return 'N/A';
      case other:
        return 'O';
    }
  }

  /// Get icon name for the gender
  String get iconName {
    switch (this) {
      case male:
        return 'male';
      case female:
        return 'female';
      case nonBinary:
        return 'transgender';
      case preferNotToSay:
        return 'help_outline';
      case other:
        return 'more_horiz';
    }
  }

  /// Get pronoun suggestions (common pronouns, not exhaustive)
  List<String> get commonPronouns {
    switch (this) {
      case male:
        return ['he/him', 'he/they'];
      case female:
        return ['she/her', 'she/they'];
      case nonBinary:
        return ['they/them', 'xe/xir', 'ze/hir'];
      case preferNotToSay:
        return ['they/them'];
      case other:
        return ['they/them'];
    }
  }

  /// Create from string value
  static AtomicGender fromString(String value) {
    switch (value.toLowerCase()) {
      case 'male':
      case 'm':
        return male;
      case 'female':
      case 'f':
        return female;
      case 'nonbinary':
      case 'non-binary':
      case 'nb':
        return nonBinary;
      case 'prefernottosay':
      case 'prefer not to say':
      case 'na':
      case 'n/a':
        return preferNotToSay;
      case 'other':
      case 'o':
        return other;
      default:
        return preferNotToSay;
    }
  }

  /// Convert to string
  String get value => name;

  /// Get API value (for backend compatibility)
  String get apiValue {
    switch (this) {
      case male:
        return 'MALE';
      case female:
        return 'FEMALE';
      case nonBinary:
        return 'NON_BINARY';
      case preferNotToSay:
        return 'PREFER_NOT_TO_SAY';
      case other:
        return 'OTHER';
    }
  }

  /// Create from API value
  static AtomicGender fromApiValue(String value) {
    switch (value.toUpperCase()) {
      case 'MALE':
        return male;
      case 'FEMALE':
        return female;
      case 'NON_BINARY':
        return nonBinary;
      case 'PREFER_NOT_TO_SAY':
        return preferNotToSay;
      case 'OTHER':
        return other;
      default:
        return preferNotToSay;
    }
  }

  /// Get options for form dropdowns
  static List<AtomicGender> get formOptions => [
    male,
    female,
    nonBinary,
    preferNotToSay,
    other,
  ];

  /// Get basic options (traditional binary)
  static List<AtomicGender> get basicOptions => [
    male,
    female,
  ];

  /// Get inclusive options (modern inclusive list)
  static List<AtomicGender> get inclusiveOptions => [
    male,
    female,
    nonBinary,
    preferNotToSay,
  ];
} 