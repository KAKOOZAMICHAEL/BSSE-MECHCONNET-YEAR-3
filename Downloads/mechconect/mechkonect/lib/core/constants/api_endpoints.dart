class ApiEndpoints {
  // Base URL - Update with your backend URL
  static const String baseUrl = 'https://api.mechkonect.com/v1';
  
  // Authentication
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String verifyOtp = '/auth/verify-otp';
  static const String resendOtp = '/auth/resend-otp';
  static const String googleSignIn = '/auth/google';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';
  
  // User
  static const String userProfile = '/user/profile';
  static const String updateProfile = '/user/profile';
  static const String updatePhone = '/user/phone';
  
  // Mechanics
  static const String mechanics = '/mechanics';
  static String mechanicById(String id) => '/mechanics/$id';
  static String mechanicReviews(String id) => '/mechanics/$id/reviews';
  static String mechanicAvailability(String id) => '/mechanics/$id/availability';
  static const String searchMechanics = '/mechanics/search';
  static const String nearbyMechanics = '/mechanics/nearby';
  
  // Bookings
  static const String bookings = '/bookings';
  static String bookingById(String id) => '/bookings/$id';
  static String bookingStatus(String id) => '/bookings/$id/status';
  static String bookingTrack(String id) => '/bookings/$id/track';
  static const String bookingHistory = '/bookings/history';
  static String cancelBooking(String id) => '/bookings/$id/cancel';
  
  // Payments
  static const String wallet = '/payments/wallet';
  static const String walletBalance = '/payments/wallet/balance';
  static const String addFunds = '/payments/wallet/add';
  static const String transactions = '/payments/transactions';
  static const String processPayment = '/payments/process';
  
  // Reviews
  static const String reviews = '/reviews';
  static String reviewById(String id) => '/reviews/$id';
  
  // Emergency
  static const String emergency = '/emergency';
  static const String emergencyContacts = '/emergency/contacts';
  
  // Location
  static const String updateLocation = '/location/update';
  
  // Notifications
  static const String notifications = '/notifications';
  static String markNotificationRead(String id) => '/notifications/$id/read';
}

