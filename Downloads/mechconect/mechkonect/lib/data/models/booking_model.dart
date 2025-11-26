import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'booking_model.g.dart';

enum BookingStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('confirmed')
  confirmed,
  @JsonValue('in_progress')
  inProgress,
  @JsonValue('completed')
  completed,
  @JsonValue('cancelled')
  cancelled,
}

enum ServiceType {
  @JsonValue('minor')
  minor,
  @JsonValue('severe')
  severe,
  @JsonValue('unsure')
  unsure,
}

@JsonSerializable()
class BookingModel extends Equatable {
  final String id;
  final String userId;
  final String mechanicId;
  final String? mechanicName;
  final String? mechanicPhone;
  final String? mechanicPhotoUrl;
  final ServiceType serviceType;
  final String? vehicleModel;
  final String? specialInstructions;
  final double? cost;
  final BookingStatus status;
  final DateTime createdAt;
  final DateTime? scheduledTime;
  final DateTime? completedAt;
  final double? userLatitude;
  final double? userLongitude;
  final String? userAddress;
  final Map<String, dynamic>? diagnosticAnswers; // For "unsure" service type

  const BookingModel({
    required this.id,
    required this.userId,
    required this.mechanicId,
    this.mechanicName,
    this.mechanicPhone,
    this.mechanicPhotoUrl,
    required this.serviceType,
    this.vehicleModel,
    this.specialInstructions,
    this.cost,
    required this.status,
    required this.createdAt,
    this.scheduledTime,
    this.completedAt,
    this.userLatitude,
    this.userLongitude,
    this.userAddress,
    this.diagnosticAnswers,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) =>
      _$BookingModelFromJson(json);

  Map<String, dynamic> toJson() => _$BookingModelToJson(this);

  BookingModel copyWith({
    String? id,
    String? userId,
    String? mechanicId,
    String? mechanicName,
    String? mechanicPhone,
    String? mechanicPhotoUrl,
    ServiceType? serviceType,
    String? vehicleModel,
    String? specialInstructions,
    double? cost,
    BookingStatus? status,
    DateTime? createdAt,
    DateTime? scheduledTime,
    DateTime? completedAt,
    double? userLatitude,
    double? userLongitude,
    String? userAddress,
    Map<String, dynamic>? diagnosticAnswers,
  }) {
    return BookingModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      mechanicId: mechanicId ?? this.mechanicId,
      mechanicName: mechanicName ?? this.mechanicName,
      mechanicPhone: mechanicPhone ?? this.mechanicPhone,
      mechanicPhotoUrl: mechanicPhotoUrl ?? this.mechanicPhotoUrl,
      serviceType: serviceType ?? this.serviceType,
      vehicleModel: vehicleModel ?? this.vehicleModel,
      specialInstructions: specialInstructions ?? this.specialInstructions,
      cost: cost ?? this.cost,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      completedAt: completedAt ?? this.completedAt,
      userLatitude: userLatitude ?? this.userLatitude,
      userLongitude: userLongitude ?? this.userLongitude,
      userAddress: userAddress ?? this.userAddress,
      diagnosticAnswers: diagnosticAnswers ?? this.diagnosticAnswers,
    );
  }

  bool get canBeCancelled =>
      status == BookingStatus.pending || status == BookingStatus.confirmed;

  bool get canBeRated =>
      status == BookingStatus.completed;

  @override
  List<Object?> get props => [
        id,
        userId,
        mechanicId,
        mechanicName,
        mechanicPhone,
        mechanicPhotoUrl,
        serviceType,
        vehicleModel,
        specialInstructions,
        cost,
        status,
        createdAt,
        scheduledTime,
        completedAt,
        userLatitude,
        userLongitude,
        userAddress,
        diagnosticAnswers,
      ];
}

