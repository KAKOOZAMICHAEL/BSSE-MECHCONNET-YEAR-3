import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  // Heading Styles
  static TextStyle h1({Color? color, bool isDark = false}) {
    return GoogleFonts.poppins(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: color ?? (isDark ? AppTextStyles.textPrimaryDark : AppTextStyles.textPrimary),
      height: 1.2,
    );
  }
  
  static TextStyle h2({Color? color, bool isDark = false}) {
    return GoogleFonts.poppins(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: color ?? (isDark ? AppTextStyles.textPrimaryDark : AppTextStyles.textPrimary),
      height: 1.3,
    );
  }
  
  static TextStyle h3({Color? color, bool isDark = false}) {
    return GoogleFonts.poppins(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: color ?? (isDark ? AppTextStyles.textPrimaryDark : AppTextStyles.textPrimary),
      height: 1.4,
    );
  }
  
  static TextStyle h4({Color? color, bool isDark = false}) {
    return GoogleFonts.poppins(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: color ?? (isDark ? AppTextStyles.textPrimaryDark : AppTextStyles.textPrimary),
      height: 1.4,
    );
  }
  
  // Body Styles
  static TextStyle bodyLarge({Color? color, bool isDark = false}) {
    return GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: color ?? (isDark ? AppTextStyles.textPrimaryDark : AppTextStyles.textPrimary),
      height: 1.5,
    );
  }
  
  static TextStyle bodyMedium({Color? color, bool isDark = false}) {
    return GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: color ?? (isDark ? AppTextStyles.textPrimaryDark : AppTextStyles.textPrimary),
      height: 1.5,
    );
  }
  
  static TextStyle bodySmall({Color? color, bool isDark = false}) {
    return GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: color ?? (isDark ? AppTextStyles.textSecondaryDark : AppTextStyles.textSecondary),
      height: 1.5,
    );
  }
  
  // Button Styles
  static TextStyle buttonLarge({Color? color}) {
    return GoogleFonts.poppins(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: color ?? Colors.white,
      letterSpacing: 0.5,
    );
  }
  
  static TextStyle buttonMedium({Color? color}) {
    return GoogleFonts.poppins(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: color ?? Colors.white,
      letterSpacing: 0.5,
    );
  }
  
  // Caption Styles
  static TextStyle caption({Color? color, bool isDark = false}) {
    return GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: color ?? (isDark ? AppTextStyles.textSecondaryDark : AppTextStyles.textSecondary),
      height: 1.4,
    );
  }
  
  // Overline Styles
  static TextStyle overline({Color? color, bool isDark = false}) {
    return GoogleFonts.inter(
      fontSize: 10,
      fontWeight: FontWeight.w500,
      color: color ?? (isDark ? AppTextStyles.textSecondaryDark : AppTextStyles.textSecondary),
      letterSpacing: 1.5,
      height: 1.4,
    );
  }
  
  // Color references
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFFB0B0B0);
}

