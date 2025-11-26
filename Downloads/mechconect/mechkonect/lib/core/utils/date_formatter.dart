import 'package:intl/intl.dart';

class DateFormatter {
  // Format date as "Jan 15, 2024"
  static String formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }
  
  // Format date as "15/01/2024"
  static String formatDateShort(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }
  
  // Format date and time as "Jan 15, 2024 at 3:30 PM"
  static String formatDateTime(DateTime dateTime) {
    return DateFormat('MMM dd, yyyy \'at\' hh:mm a').format(dateTime);
  }
  
  // Format time as "3:30 PM"
  static String formatTime(DateTime dateTime) {
    return DateFormat('hh:mm a').format(dateTime);
  }
  
  // Format time as "15:30"
  static String formatTime24(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
  }
  
  // Format relative time (e.g., "2 hours ago", "Yesterday", "3 days ago")
  static String formatRelative(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'Just now';
        }
        return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
      }
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks week${weeks == 1 ? '' : 's'} ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months month${months == 1 ? '' : 's'} ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years year${years == 1 ? '' : 's'} ago';
    }
  }
  
  // Format for booking timestamps
  static String formatBookingDate(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final bookingDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
    
    if (bookingDate == today) {
      return 'Today at ${formatTime(dateTime)}';
    } else if (bookingDate == today.subtract(const Duration(days: 1))) {
      return 'Yesterday at ${formatTime(dateTime)}';
    } else if (bookingDate.isAfter(today.subtract(const Duration(days: 7)))) {
      return DateFormat('EEEE at hh:mm a').format(dateTime);
    } else {
      return formatDateTime(dateTime);
    }
  }
  
  // Format for transaction history
  static String formatTransactionDate(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final transactionDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
    
    if (transactionDate == today) {
      return 'Today';
    } else if (transactionDate == today.subtract(const Duration(days: 1))) {
      return 'Yesterday';
    } else {
      return formatDateShort(dateTime);
    }
  }
  
  // Parse date from string (ISO format)
  static DateTime? parseDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) {
      return null;
    }
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      return null;
    }
  }
  
  // Format date for API (ISO format)
  static String formatDateForApi(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }
  
  // Format datetime for API (ISO format)
  static String formatDateTimeForApi(DateTime dateTime) {
    return dateTime.toIso8601String();
  }
}

