import 'package:intl/intl.dart';

class CurrencyFormatter {
  // Format currency for Uganda (UGX - Ugandan Shilling)
  static String formatUGX(double amount, {bool showSymbol = true}) {
    final formatter = NumberFormat.currency(
      symbol: showSymbol ? 'UGX ' : '',
      decimalDigits: 0,
      locale: 'en_US',
    );
    return formatter.format(amount);
  }
  
  // Format currency without symbol
  static String formatAmount(double amount) {
    return formatUGX(amount, showSymbol: false);
  }
  
  // Format currency with symbol
  static String formatCurrency(double amount) {
    return formatUGX(amount, showSymbol: true);
  }
  
  // Format large amounts (e.g., 1,000,000 UGX)
  static String formatLargeAmount(double amount) {
    if (amount >= 1000000) {
      final millions = amount / 1000000;
      return '${millions.toStringAsFixed(1)}M UGX';
    } else if (amount >= 1000) {
      final thousands = amount / 1000;
      return '${thousands.toStringAsFixed(1)}K UGX';
    }
    return formatCurrency(amount);
  }
  
  // Parse currency string to double
  static double? parseAmount(String? amountString) {
    if (amountString == null || amountString.isEmpty) {
      return null;
    }
    
    // Remove currency symbols and spaces
    String cleaned = amountString
        .replaceAll('UGX', '')
        .replaceAll(',', '')
        .replaceAll(' ', '')
        .trim();
    
    try {
      return double.parse(cleaned);
    } catch (e) {
      return null;
    }
  }
  
  // Format price range
  static String formatPriceRange(double min, double max) {
    return '${formatCurrency(min)} - ${formatCurrency(max)}';
  }
  
  // Format estimated cost
  static String formatEstimatedCost(double amount) {
    return '~${formatCurrency(amount)}';
  }
}

