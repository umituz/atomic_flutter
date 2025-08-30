enum AtomicGender {
  male,

  female,

  nonBinary,

  preferNotToSay,

  other;

  bool get isMale => this == male;

  bool get isFemale => this == female;

  bool get isNonBinary => this == nonBinary;

  bool get isPreferNotToSay => this == preferNotToSay;

  bool get isOther => this == other;

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

  String get value => name;

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

  static List<AtomicGender> get formOptions => [
        male,
        female,
        nonBinary,
        preferNotToSay,
        other,
      ];

  static List<AtomicGender> get basicOptions => [
        male,
        female,
      ];

  static List<AtomicGender> get inclusiveOptions => [
        male,
        female,
        nonBinary,
        preferNotToSay,
      ];
}
