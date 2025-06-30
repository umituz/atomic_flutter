/// DateTime utility functions for Atomic Flutter
/// Provides safe parsing, formatting, and common date operations
library atomic_date_time_utils;

import 'package:intl/intl.dart';

/// Atomic DateTime Utilities
/// Centralized date/time parsing, formatting, and validation
class AtomicDateTimeUtils {
  AtomicDateTimeUtils._(); // Private constructor

  // ===== PARSING UTILITIES =====

  /// Safely parse DateTime from string with fallback
  /// Returns null if parsing fails instead of throwing exception
  static DateTime? parseDateTime(String? dateString) {
    if (dateString == null || dateString.isEmpty) {
      return null;
    }
    
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      return DateTime.tryParse(dateString);
    }
  }

  /// Parse DateTime with custom format
  static DateTime? parseDateTimeWithFormat(String? dateString, String format) {
    if (dateString == null || dateString.isEmpty) {
      return null;
    }
    
    try {
      final formatter = DateFormat(format);
      return formatter.parse(dateString);
    } catch (e) {
      return null;
    }
  }

  /// Parse DateTime from milliseconds since epoch
  static DateTime? parseFromMilliseconds(int? milliseconds) {
    if (milliseconds == null) return null;
    
    try {
      return DateTime.fromMillisecondsSinceEpoch(milliseconds);
    } catch (e) {
      return null;
    }
  }

  /// Parse DateTime from seconds since epoch
  static DateTime? parseFromSeconds(int? seconds) {
    if (seconds == null) return null;
    
    try {
      return DateTime.fromMillisecondsSinceEpoch(seconds * 1000);
    } catch (e) {
      return null;
    }
  }

  /// Parse DateTime from ISO 8601 string (strict)
  static DateTime? parseIso8601(String? dateString) {
    if (dateString == null || dateString.isEmpty) {
      return null;
    }
    
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      return null;
    }
  }

  /// Parse DateTime from JSON (handles various formats)
  static DateTime? parseFromJson(dynamic value) {
    if (value == null) return null;
    
    if (value is String) {
      return parseDateTime(value);
    } else if (value is int) {
      // Try milliseconds first, then seconds
      final asMillis = parseFromMilliseconds(value);
      if (asMillis != null && asMillis.year > 1980 && asMillis.year < 2100) {
        return asMillis;
      }
      return parseFromSeconds(value);
    } else if (value is DateTime) {
      return value;
    }
    
    return null;
  }

  // ===== FORMATTING UTILITIES =====

  /// Format DateTime to ISO 8601 string (safe)
  static String? formatToIso8601(DateTime? dateTime) {
    return dateTime?.toIso8601String();
  }

  /// Format DateTime with custom format
  static String? formatWithPattern(DateTime? dateTime, String pattern) {
    if (dateTime == null) return null;
    
    try {
      final formatter = DateFormat(pattern);
      return formatter.format(dateTime);
    } catch (e) {
      return dateTime.toIso8601String();
    }
  }

  /// Format DateTime for database storage (UTC ISO 8601)
  static String? formatForDatabase(DateTime? dateTime) {
    if (dateTime == null) return null;
    return dateTime.toUtc().toIso8601String();
  }

  /// Format DateTime for display (localized)
  static String? formatForDisplay(DateTime? dateTime, {String? locale}) {
    if (dateTime == null) return null;
    
    try {
      final formatter = DateFormat.yMMMd(locale);
      return formatter.format(dateTime);
    } catch (e) {
      return formatWithPattern(dateTime, 'dd/MM/yyyy');
    }
  }

  /// Format DateTime for API (standard format)
  static String? formatForApi(DateTime? dateTime) {
    return formatToIso8601(dateTime);
  }

  // ===== COMMON FORMATS =====

  /// Format as date only (dd/MM/yyyy)
  static String? formatDateOnly(DateTime? dateTime) {
    return formatWithPattern(dateTime, 'dd/MM/yyyy');
  }

  /// Format as time only (HH:mm)
  static String? formatTimeOnly(DateTime? dateTime) {
    return formatWithPattern(dateTime, 'HH:mm');
  }

  /// Format as date and time (dd/MM/yyyy HH:mm)
  static String? formatDateTime(DateTime? dateTime) {
    return formatWithPattern(dateTime, 'dd/MM/yyyy HH:mm');
  }

  /// Format relative time (e.g., "2 minutes ago")
  static String formatRelativeTime(DateTime? dateTime) {
    if (dateTime == null) return 'Unknown time';
    
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      return '$minutes ${minutes == 1 ? 'minute' : 'minutes'} ago';
    } else if (difference.inHours < 24) {
      final hours = difference.inHours;
      return '$hours ${hours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inDays < 30) {
      final days = difference.inDays;
      return '$days ${days == 1 ? 'day' : 'days'} ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    }
  }

  // ===== VALIDATION UTILITIES =====

  /// Check if DateTime is in the past
  static bool isInPast(DateTime? dateTime) {
    if (dateTime == null) return false;
    return dateTime.isBefore(DateTime.now());
  }

  /// Check if DateTime is in the future
  static bool isInFuture(DateTime? dateTime) {
    if (dateTime == null) return false;
    return dateTime.isAfter(DateTime.now());
  }

  /// Check if DateTime is today
  static bool isToday(DateTime? dateTime) {
    if (dateTime == null) return false;
    final now = DateTime.now();
    return dateTime.year == now.year &&
           dateTime.month == now.month &&
           dateTime.day == now.day;
  }

  /// Check if DateTime is yesterday
  static bool isYesterday(DateTime? dateTime) {
    if (dateTime == null) return false;
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return dateTime.year == yesterday.year &&
           dateTime.month == yesterday.month &&
           dateTime.day == yesterday.day;
  }

  /// Check if DateTime is within range
  static bool isWithinRange(DateTime? dateTime, DateTime start, DateTime end) {
    if (dateTime == null) return false;
    return dateTime.isAfter(start) && dateTime.isBefore(end);
  }

  /// Check if two DateTimes are on the same day
  static bool isSameDay(DateTime? date1, DateTime? date2) {
    if (date1 == null || date2 == null) return false;
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }

  // ===== CALCULATION UTILITIES =====

  /// Calculate age in years
  static int calculateAge(DateTime? birthDate) {
    if (birthDate == null) return 0;
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month || 
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  /// Get start of day (00:00:00)
  static DateTime? startOfDay(DateTime? dateTime) {
    if (dateTime == null) return null;
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  /// Get end of day (23:59:59.999)
  static DateTime? endOfDay(DateTime? dateTime) {
    if (dateTime == null) return null;
    return DateTime(dateTime.year, dateTime.month, dateTime.day, 23, 59, 59, 999);
  }

  /// Get start of week (Monday)
  static DateTime? startOfWeek(DateTime? dateTime) {
    if (dateTime == null) return null;
    final monday = dateTime.subtract(Duration(days: dateTime.weekday - 1));
    return startOfDay(monday);
  }

  /// Get start of month
  static DateTime? startOfMonth(DateTime? dateTime) {
    if (dateTime == null) return null;
    return DateTime(dateTime.year, dateTime.month, 1);
  }

  /// Get start of year
  static DateTime? startOfYear(DateTime? dateTime) {
    if (dateTime == null) return null;
    return DateTime(dateTime.year, 1, 1);
  }

  // ===== CONVENIENCE METHODS =====

  /// Get current timestamp as ISO 8601 string
  static String get currentTimestamp => DateTime.now().toIso8601String();

  /// Get current UTC timestamp as ISO 8601 string
  static String get currentUtcTimestamp => DateTime.now().toUtc().toIso8601String();

  /// Create DateTime from date components
  static DateTime? createDateTime({
    required int year,
    int month = 1,
    int day = 1,
    int hour = 0,
    int minute = 0,
    int second = 0,
    int millisecond = 0,
  }) {
    try {
      return DateTime(year, month, day, hour, minute, second, millisecond);
    } catch (e) {
      return null;
    }
  }

  /// Add business days (skip weekends)
  static DateTime? addBusinessDays(DateTime? dateTime, int days) {
    if (dateTime == null) return null;
    
    var result = dateTime;
    var remaining = days;
    
    while (remaining > 0) {
      result = result!.add(const Duration(days: 1));
      // Skip weekends (Saturday = 6, Sunday = 7)
      if (result.weekday < 6) {
        remaining--;
      }
    }
    
    return result;
  }
}

/// Extension methods for DateTime
extension AtomicDateTimeExtension on DateTime {
  /// Format this DateTime using AtomicDateTimeUtils
  String get toDisplayString => AtomicDateTimeUtils.formatForDisplay(this) ?? toString();
  
  /// Format this DateTime for database
  String get toDatabaseString => AtomicDateTimeUtils.formatForDatabase(this) ?? toIso8601String();
  
  /// Format this DateTime for API
  String get toApiString => AtomicDateTimeUtils.formatForApi(this) ?? toIso8601String();
  
  /// Get relative time string
  String get toRelativeString => AtomicDateTimeUtils.formatRelativeTime(this);
  
  /// Check if this DateTime is today
  bool get isToday => AtomicDateTimeUtils.isToday(this);
  
  /// Check if this DateTime is yesterday
  bool get isYesterday => AtomicDateTimeUtils.isYesterday(this);
  
  /// Check if this DateTime is in the past
  bool get isInPast => AtomicDateTimeUtils.isInPast(this);
  
  /// Check if this DateTime is in the future
  bool get isInFuture => AtomicDateTimeUtils.isInFuture(this);
  
  /// Get start of this day
  DateTime get startOfDay => AtomicDateTimeUtils.startOfDay(this)!;
  
  /// Get end of this day
  DateTime get endOfDay => AtomicDateTimeUtils.endOfDay(this)!;
  
  /// Get start of this week
  DateTime get startOfWeek => AtomicDateTimeUtils.startOfWeek(this)!;
  
  /// Get start of this month
  DateTime get startOfMonth => AtomicDateTimeUtils.startOfMonth(this)!;
  
  /// Get start of this year
  DateTime get startOfYear => AtomicDateTimeUtils.startOfYear(this)!;
}