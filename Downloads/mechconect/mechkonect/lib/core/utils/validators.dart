class Validators {
  // Phone number validation (Ugandan format: 256XXXXXXXXX)
  static String? phoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    
    // Remove spaces, dashes, and plus signs
    String cleaned = value.replaceAll(RegExp(r'[\s\-+]'), '');
    
    // Check if it starts with 256 (Uganda country code)
    if (cleaned.startsWith('256')) {
      if (cleaned.length == 12) {
        return null;
      }
      return 'Invalid phone number format';
    }
    
    // Check if it starts with 0 (local format)
    if (cleaned.startsWith('0')) {
      if (cleaned.length == 10) {
        return null;
      }
      return 'Invalid phone number format';
    }
    
    return 'Phone number must start with 256 or 0';
  }
  
  // Email validation
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    
    return null;
  }
  
  // Username validation
  static String? username(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username is required';
    }
    
    if (value.length < 3) {
      return 'Username must be at least 3 characters';
    }
    
    if (value.length > 20) {
      return 'Username must be less than 20 characters';
    }
    
    final usernameRegex = RegExp(r'^[a-zA-Z0-9_]+$');
    if (!usernameRegex.hasMatch(value)) {
      return 'Username can only contain letters, numbers, and underscores';
    }
    
    return null;
  }
  
  // NIN (National Identification Number) validation
  static String? nin(String? value) {
    if (value == null || value.isEmpty) {
      return 'NIN is required';
    }
    
    // Ugandan NIN format: typically 14 characters (letters and numbers)
    if (value.length < 10 || value.length > 20) {
      return 'NIN must be between 10 and 20 characters';
    }
    
    return null;
  }
  
  // Permit Number validation - Format: PERMIT + 4 digits + 1 letter (e.g., PERMIT2025A)
  static String? permitNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Permit number is required';
    }
    // Format: PERMIT followed by 4 digits and 1 letter
    final pattern = RegExp(r'^PERMIT\d{4}[A-Z]$');
    if (!pattern.hasMatch(value)) {
      return 'Permit format must be PERMIT + 4 digits + 1 letter (e.g., PERMIT2025A)';
    }
    return null;
  }
  
  // OTP validation (6 digits)
  static String? otp(String? value) {
    if (value == null || value.isEmpty) {
      return 'OTP is required';
    }
    
    if (value.length != 6) {
      return 'OTP must be 6 digits';
    }
    
    final otpRegex = RegExp(r'^\d{6}$');
    if (!otpRegex.hasMatch(value)) {
      return 'OTP must contain only numbers';
    }
    
    return null;
  }
  
  // Required field validation
  static String? required(String? value, [String? fieldName]) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    return null;
  }
  
  // Minimum length validation
  static String? minLength(String? value, int minLength, [String? fieldName]) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    
    if (value.length < minLength) {
      return '${fieldName ?? 'This field'} must be at least $minLength characters';
    }
    
    return null;
  }
  
  // Maximum length validation
  static String? maxLength(String? value, int maxLength, [String? fieldName]) {
    if (value == null || value.isEmpty) {
      return null;
    }
    
    if (value.length > maxLength) {
      return '${fieldName ?? 'This field'} must be less than $maxLength characters';
    }
    
    return null;
  }
  
  // Password validation
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }
    
    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least one lowercase letter';
    }
    
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }
    
    return null;
  }
  
  // Vehicle model validation
  static String? vehicleModel(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vehicle model is required';
    }
    
    if (value.length < 2) {
      return 'Vehicle model must be at least 2 characters';
    }
    
    return null;
  }
}

