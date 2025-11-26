// GENERATED CODE - DO NOT MODIFY BY HAND
part of 'api_service.dart';

ApiService _$ApiService(Dio dio, {String baseUrl = ''}) {
  return _ApiService(dio, baseUrl: baseUrl);
}

class _ApiService implements ApiService {
  final Dio _dio;
  final String? _baseUrl;

  _ApiService(this._dio, {String baseUrl = ''}) : _baseUrl = baseUrl;

  @override
  Future<Map<String, dynamic>> login(Map<String, dynamic> data) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = data;
    final _result = await _dio.fetch<Map<String, dynamic>>(
      _setStreamType<Map<String, dynamic>>(
        Options(
          method: 'POST',
          headers: _headers,
          extra: _extra,
        )
            .compose(
              _dio.options,
              '/auth/login',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: _baseUrl ?? _dio.options.baseUrl),
      ),
    );
    return _result.data!;
  }

  @override
  Future<UserModel> register(Map<String, dynamic> data) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = data;
    final _result = await _dio.fetch<Map<String, dynamic>>(
      _setStreamType<UserModel>(
        Options(
          method: 'POST',
          headers: _headers,
          extra: _extra,
        )
            .compose(
              _dio.options,
              '/auth/register',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: _baseUrl ?? _dio.options.baseUrl),
      ),
    );
    return UserModel.fromJson(_result.data!);
  }

  @override
  Future<Map<String, dynamic>> verifyOtp(Map<String, dynamic> data) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = data;
    final _result = await _dio.fetch<Map<String, dynamic>>(
      _setStreamType<Map<String, dynamic>>(
        Options(
          method: 'POST',
          headers: _headers,
          extra: _extra,
        )
            .compose(
              _dio.options,
              '/auth/verify-otp',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: _baseUrl ?? _dio.options.baseUrl),
      ),
    );
    return _result.data!;
  }

  @override
  Future<void> resendOtp(Map<String, dynamic> data) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = data;
    await _dio.fetch<void>(
      _setStreamType<void>(
        Options(
          method: 'POST',
          headers: _headers,
          extra: _extra,
        )
            .compose(
              _dio.options,
              '/auth/resend-otp',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: _baseUrl ?? _dio.options.baseUrl),
      ),
    );
  }

  @override
  Future<Map<String, dynamic>> googleSignIn(Map<String, dynamic> data) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = data;
    final _result = await _dio.fetch<Map<String, dynamic>>(
      _setStreamType<Map<String, dynamic>>(
        Options(
          method: 'POST',
          headers: _headers,
          extra: _extra,
        )
            .compose(
              _dio.options,
              '/auth/google',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: _baseUrl ?? _dio.options.baseUrl),
      ),
    );
    return _result.data!;
  }

  @override
  Future<UserModel> getUserProfile() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
      _setStreamType<UserModel>(
        Options(
          method: 'GET',
          headers: _headers,
          extra: _extra,
        )
            .compose(
              _dio.options,
              '/user/profile',
              queryParameters: queryParameters,
            )
            .copyWith(baseUrl: _baseUrl ?? _dio.options.baseUrl),
      ),
    );
    return UserModel.fromJson(_result.data!);
  }

  @override
  Future<UserModel> updateProfile(Map<String, dynamic> data) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = data;
    final _result = await _dio.fetch<Map<String, dynamic>>(
      _setStreamType<UserModel>(
        Options(
          method: 'PUT',
          headers: _headers,
          extra: _extra,
        )
            .compose(
              _dio.options,
              '/user/profile',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: _baseUrl ?? _dio.options.baseUrl),
      ),
    );
    return UserModel.fromJson(_result.data!);
  }

  @override
  Future<List<MechanicModel>> getMechanics(
      Map<String, dynamic>? queries) async {
    const _extra = <String, dynamic>{};
    final queryParameters = queries ?? <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _result = await _dio.fetch<List<dynamic>>(
      _setStreamType<List<MechanicModel>>(
        Options(
          method: 'GET',
          headers: _headers,
          extra: _extra,
        )
            .compose(
              _dio.options,
              '/mechanics',
              queryParameters: queryParameters,
            )
            .copyWith(baseUrl: _baseUrl ?? _dio.options.baseUrl),
      ),
    );
    var value = _result.data!
        .map((dynamic i) => MechanicModel.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<MechanicModel> getMechanic(String id) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
      _setStreamType<MechanicModel>(
        Options(
          method: 'GET',
          headers: _headers,
          extra: _extra,
        )
            .compose(
              _dio.options,
              '/mechanics/$id',
              queryParameters: queryParameters,
            )
            .copyWith(baseUrl: _baseUrl ?? _dio.options.baseUrl),
      ),
    );
    return MechanicModel.fromJson(_result.data!);
  }

  @override
  Future<List<ReviewModel>> getMechanicReviews(String id) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _result = await _dio.fetch<List<dynamic>>(
      _setStreamType<List<ReviewModel>>(
        Options(
          method: 'GET',
          headers: _headers,
          extra: _extra,
        )
            .compose(
              _dio.options,
              '/mechanics/$id/reviews',
              queryParameters: queryParameters,
            )
            .copyWith(baseUrl: _baseUrl ?? _dio.options.baseUrl),
      ),
    );
    var value = _result.data!
        .map((dynamic i) => ReviewModel.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<List<MechanicModel>> getNearbyMechanics(
    double latitude,
    double longitude,
    double? radius,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'latitude': latitude,
      r'longitude': longitude,
      if (radius != null) r'radius': radius,
    };
    final _headers = <String, dynamic>{};
    final _result = await _dio.fetch<List<dynamic>>(
      _setStreamType<List<MechanicModel>>(
        Options(
          method: 'GET',
          headers: _headers,
          extra: _extra,
        )
            .compose(
              _dio.options,
              '/mechanics/nearby',
              queryParameters: queryParameters,
            )
            .copyWith(baseUrl: _baseUrl ?? _dio.options.baseUrl),
      ),
    );
    var value = _result.data!
        .map((dynamic i) => MechanicModel.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<List<MechanicModel>> searchMechanics(String query) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'query': query};
    final _headers = <String, dynamic>{};
    final _result = await _dio.fetch<List<dynamic>>(
      _setStreamType<List<MechanicModel>>(
        Options(
          method: 'GET',
          headers: _headers,
          extra: _extra,
        )
            .compose(
              _dio.options,
              '/mechanics/search',
              queryParameters: queryParameters,
            )
            .copyWith(baseUrl: _baseUrl ?? _dio.options.baseUrl),
      ),
    );
    var value = _result.data!
        .map((dynamic i) => MechanicModel.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<BookingModel> createBooking(Map<String, dynamic> data) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = data;
    final _result = await _dio.fetch<Map<String, dynamic>>(
      _setStreamType<BookingModel>(
        Options(
          method: 'POST',
          headers: _headers,
          extra: _extra,
        )
            .compose(
              _dio.options,
              '/bookings',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: _baseUrl ?? _dio.options.baseUrl),
      ),
    );
    return BookingModel.fromJson(_result.data!);
  }

  @override
  Future<List<BookingModel>> getBookings(
      Map<String, dynamic>? queries) async {
    const _extra = <String, dynamic>{};
    final queryParameters = queries ?? <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _result = await _dio.fetch<List<dynamic>>(
      _setStreamType<List<BookingModel>>(
        Options(
          method: 'GET',
          headers: _headers,
          extra: _extra,
        )
            .compose(
              _dio.options,
              '/bookings',
              queryParameters: queryParameters,
            )
            .copyWith(baseUrl: _baseUrl ?? _dio.options.baseUrl),
      ),
    );
    var value = _result.data!
        .map((dynamic i) => BookingModel.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<BookingModel> getBooking(String id) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
      _setStreamType<BookingModel>(
        Options(
          method: 'GET',
          headers: _headers,
          extra: _extra,
        )
            .compose(
              _dio.options,
              '/bookings/$id',
              queryParameters: queryParameters,
            )
            .copyWith(baseUrl: _baseUrl ?? _dio.options.baseUrl),
      ),
    );
    return BookingModel.fromJson(_result.data!);
  }

  @override
  Future<BookingModel> updateBookingStatus(
    String id,
    Map<String, dynamic> data,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = data;
    final _result = await _dio.fetch<Map<String, dynamic>>(
      _setStreamType<BookingModel>(
        Options(
          method: 'PUT',
          headers: _headers,
          extra: _extra,
        )
            .compose(
              _dio.options,
              '/bookings/$id/status',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: _baseUrl ?? _dio.options.baseUrl),
      ),
    );
    return BookingModel.fromJson(_result.data!);
  }

  @override
  Future<Map<String, dynamic>> trackBooking(String id) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
      _setStreamType<Map<String, dynamic>>(
        Options(
          method: 'GET',
          headers: _headers,
          extra: _extra,
        )
            .compose(
              _dio.options,
              '/bookings/$id/track',
              queryParameters: queryParameters,
            )
            .copyWith(baseUrl: _baseUrl ?? _dio.options.baseUrl),
      ),
    );
    return _result.data!;
  }

  @override
  Future<Map<String, dynamic>> getWalletBalance() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
      _setStreamType<Map<String, dynamic>>(
        Options(
          method: 'GET',
          headers: _headers,
          extra: _extra,
        )
            .compose(
              _dio.options,
              '/payments/wallet/balance',
              queryParameters: queryParameters,
            )
            .copyWith(baseUrl: _baseUrl ?? _dio.options.baseUrl),
      ),
    );
    return _result.data!;
  }

  @override
  Future<PaymentModel> addFunds(Map<String, dynamic> data) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = data;
    final _result = await _dio.fetch<Map<String, dynamic>>(
      _setStreamType<PaymentModel>(
        Options(
          method: 'POST',
          headers: _headers,
          extra: _extra,
        )
            .compose(
              _dio.options,
              '/payments/wallet/add',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: _baseUrl ?? _dio.options.baseUrl),
      ),
    );
    return PaymentModel.fromJson(_result.data!);
  }

  @override
  Future<List<PaymentModel>> getTransactions() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _result = await _dio.fetch<List<dynamic>>(
      _setStreamType<List<PaymentModel>>(
        Options(
          method: 'GET',
          headers: _headers,
          extra: _extra,
        )
            .compose(
              _dio.options,
              '/payments/transactions',
              queryParameters: queryParameters,
            )
            .copyWith(baseUrl: _baseUrl ?? _dio.options.baseUrl),
      ),
    );
    var value = _result.data!
        .map((dynamic i) => PaymentModel.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<PaymentModel> processPayment(Map<String, dynamic> data) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = data;
    final _result = await _dio.fetch<Map<String, dynamic>>(
      _setStreamType<PaymentModel>(
        Options(
          method: 'POST',
          headers: _headers,
          extra: _extra,
        )
            .compose(
              _dio.options,
              '/payments/process',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: _baseUrl ?? _dio.options.baseUrl),
      ),
    );
    return PaymentModel.fromJson(_result.data!);
  }

  @override
  Future<ReviewModel> createReview(Map<String, dynamic> data) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = data;
    final _result = await _dio.fetch<Map<String, dynamic>>(
      _setStreamType<ReviewModel>(
        Options(
          method: 'POST',
          headers: _headers,
          extra: _extra,
        )
            .compose(
              _dio.options,
              '/reviews',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: _baseUrl ?? _dio.options.baseUrl),
      ),
    );
    return ReviewModel.fromJson(_result.data!);
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }
}




