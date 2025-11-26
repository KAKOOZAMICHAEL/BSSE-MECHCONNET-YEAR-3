import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../core/constants/api_endpoints.dart';
import '../models/user_model.dart';
import '../models/mechanic_model.dart';
import '../models/booking_model.dart';
import '../models/payment_model.dart';
import '../models/review_model.dart';

part 'api_service.g.dart';

@RestApi()
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  // Authentication
  @POST(ApiEndpoints.login)
  Future<Map<String, dynamic>> login(@Body() Map<String, dynamic> data);

  @POST(ApiEndpoints.register)
  Future<UserModel> register(@Body() Map<String, dynamic> data);

  @POST(ApiEndpoints.verifyOtp)
  Future<Map<String, dynamic>> verifyOtp(@Body() Map<String, dynamic> data);

  @POST(ApiEndpoints.resendOtp)
  Future<void> resendOtp(@Body() Map<String, dynamic> data);

  @POST(ApiEndpoints.googleSignIn)
  Future<Map<String, dynamic>> googleSignIn(@Body() Map<String, dynamic> data);

  // User
  @GET(ApiEndpoints.userProfile)
  Future<UserModel> getUserProfile();

  @PUT(ApiEndpoints.updateProfile)
  Future<UserModel> updateProfile(@Body() Map<String, dynamic> data);

  // Mechanics
  @GET(ApiEndpoints.mechanics)
  Future<List<MechanicModel>> getMechanics(@Queries() Map<String, dynamic>? queries);

  @GET('/mechanics/{id}') // FIXED: Replaced non-const method call
  Future<MechanicModel> getMechanic(@Path('id') String id);

  @GET('/mechanics/{id}/reviews') // FIXED: Replaced non-const method call
  Future<List<ReviewModel>> getMechanicReviews(@Path('id') String id);

  @GET(ApiEndpoints.nearbyMechanics)
  Future<List<MechanicModel>> getNearbyMechanics(
    @Query('latitude') double latitude,
    @Query('longitude') double longitude,
    @Query('radius') double? radius,
  );

  @GET(ApiEndpoints.searchMechanics)
  Future<List<MechanicModel>> searchMechanics(@Query('query') String query);

  // Bookings
  @POST(ApiEndpoints.bookings)
  Future<BookingModel> createBooking(@Body() Map<String, dynamic> data);

  @GET(ApiEndpoints.bookings)
  Future<List<BookingModel>> getBookings(@Queries() Map<String, dynamic>? queries);

  @GET('/bookings/{id}') // FIXED: Replaced non-const method call
  Future<BookingModel> getBooking(@Path('id') String id);

  @PUT('/bookings/{id}/status') // FIXED: Replaced non-const method call
  Future<BookingModel> updateBookingStatus(
    @Path('id') String id,
    @Body() Map<String, dynamic> data,
  );

  @GET('/bookings/{id}/track') // FIXED: Replaced non-const method call
  Future<Map<String, dynamic>> trackBooking(@Path('id') String id);

  // Payments
  @GET(ApiEndpoints.walletBalance)
  Future<Map<String, dynamic>> getWalletBalance();

  @POST(ApiEndpoints.addFunds)
  Future<PaymentModel> addFunds(@Body() Map<String, dynamic> data);

  @GET(ApiEndpoints.transactions)
  Future<List<PaymentModel>> getTransactions();

  @POST(ApiEndpoints.processPayment)
  Future<PaymentModel> processPayment(@Body() Map<String, dynamic> data);

  // Reviews
  @POST(ApiEndpoints.reviews)
  Future<ReviewModel> createReview(@Body() Map<String, dynamic> data);
}