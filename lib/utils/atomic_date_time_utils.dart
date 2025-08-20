library atomic_date_time_utils;

import 'package:intl/intl.dart';

class AtomicDateTimeUtils {
  AtomicDateTimeUtils._(); // Private constructor


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

  static DateTime? parseFromMilliseconds(int? milliseconds) {
    if (milliseconds == null) return null;
    
    try {
      return DateTime.fromMillisecondsSinceEpoch(milliseconds);
    } catch (e) {
      return null;
    }
  }

  static DateTime? parseFromSeconds(int? seconds) {
    if (seconds == null) return null;
    
    try {
      return DateTime.fromMillisecondsSinceEpoch(seconds * 1000);
    } catch (e) {
      return null;
    }
  }

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

  static DateTime? parseFromJson(dynamic value) {
    if (value == null) return null;
    
    if (value is String) {
      return parseDateTime(value);
    } else if (value is int) {
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


  static String? formatToIso8601(DateTime? dateTime) {
    return dateTime?.toIso8601String();
  }

  static String? formatWithPattern(DateTime? dateTime, String pattern) {
    if (dateTime == null) return null;
    
    try {
      final formatter = DateFormat(pattern);
      return formatter.format(dateTime);
    } catch (e) {
      return dateTime.toIso8601String();
    }
  }

  static String? formatForDatabase(DateTime? dateTime) {
    if (dateTime == null) return null;
    return dateTime.toUtc().toIso8601String();
  }

  static String? formatForDisplay(DateTime? dateTime, {String? locale}) {
    if (dateTime == null) return null;
    
    try {
      final formatter = DateFormat.yMMMd(locale);
      return formatter.format(dateTime);
    } catch (e) {
      return formatWithPattern(dateTime, 'dd/MM/yyyy');
    }
  }

  static String? formatForApi(DateTime? dateTime) {
    return formatToIso8601(dateTime);
  }


  static String? formatDateOnly(DateTime? dateTime) {
    return formatWithPattern(dateTime, 'dd/MM/yyyy');
  }

  static String? formatTimeOnly(DateTime? dateTime) {
    return formatWithPattern(dateTime, 'HH:mm');
  }

  static String? formatDateTime(DateTime? dateTime) {
    return formatWithPattern(dateTime, 'dd/MM/yyyy HH:mm');
  }

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


  static bool isInPast(DateTime? dateTime) {
    if (dateTime == null) return false;
    return dateTime.isBefore(DateTime.now());
  }

  static bool isInFuture(DateTime? dateTime) {
    if (dateTime == null) return false;
    return dateTime.isAfter(DateTime.now());
  }

  static bool isToday(DateTime? dateTime) {
    if (dateTime == null) return false;
    final now = DateTime.now();
    return dateTime.year == now.year &&
           dateTime.month == now.month &&
           dateTime.day == now.day;
  }

  static bool isYesterday(DateTime? dateTime) {
    if (dateTime == null) return false;
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return dateTime.year == yesterday.year &&
           dateTime.month == yesterday.month &&
           dateTime.day == yesterday.day;
  }

  static bool isWithinRange(DateTime? dateTime, DateTime start, DateTime end) {
    if (dateTime == null) return false;
    return dateTime.isAfter(start) && dateTime.isBefore(end);
  }

  static bool isSameDay(DateTime? date1, DateTime? date2) {
    if (date1 == null || date2 == null) return false;
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }


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

  static DateTime? startOfDay(DateTime? dateTime) {
    if (dateTime == null) return null;
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  static DateTime? endOfDay(DateTime? dateTime) {
    if (dateTime == null) return null;
    return DateTime(dateTime.year, dateTime.month, dateTime.day, 23, 59, 59, 999);
  }

  static DateTime? startOfWeek(DateTime? dateTime) {
    if (dateTime == null) return null;
    final monday = dateTime.subtract(Duration(days: dateTime.weekday - 1));
    return startOfDay(monday);
  }

  static DateTime? startOfMonth(DateTime? dateTime) {
    if (dateTime == null) return null;
    return DateTime(dateTime.year, dateTime.month, 1);
  }

  static DateTime? startOfYear(DateTime? dateTime) {
    if (dateTime == null) return null;
    return DateTime(dateTime.year, 1, 1);
  }


  static String get currentTimestamp => DateTime.now().toIso8601String();

  static String get currentUtcTimestamp => DateTime.now().toUtc().toIso8601String();

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

  static DateTime? addBusinessDays(DateTime? dateTime, int days) {
    if (dateTime == null) return null;
    
    var result = dateTime;
    var remaining = days;
    
    while (remaining > 0) {
      result = result!.add(const Duration(days: 1));
      if (result.weekday < 6) {
        remaining--;
      }
    }
    
    return result;
  }
}

extension AtomicDateTimeExtension on DateTime {
  String get toDisplayString => AtomicDateTimeUtils.formatForDisplay(this) ?? toString();
  
  String get toDatabaseString => AtomicDateTimeUtils.formatForDatabase(this) ?? toIso8601String();
  
  String get toApiString => AtomicDateTimeUtils.formatForApi(this) ?? toIso8601String();
  
  String get toRelativeString => AtomicDateTimeUtils.formatRelativeTime(this);
  
  bool get isToday => AtomicDateTimeUtils.isToday(this);
  
  bool get isYesterday => AtomicDateTimeUtils.isYesterday(this);
  
  bool get isInPast => AtomicDateTimeUtils.isInPast(this);
  
  bool get isInFuture => AtomicDateTimeUtils.isInFuture(this);
  
  DateTime get startOfDay => AtomicDateTimeUtils.startOfDay(this)!;
  
  DateTime get endOfDay => AtomicDateTimeUtils.endOfDay(this)!;
  
  DateTime get startOfWeek => AtomicDateTimeUtils.startOfWeek(this)!;
  
  DateTime get startOfMonth => AtomicDateTimeUtils.startOfMonth(this)!;
  
  DateTime get startOfYear => AtomicDateTimeUtils.startOfYear(this)!;
}