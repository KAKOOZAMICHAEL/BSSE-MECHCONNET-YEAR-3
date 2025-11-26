import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'mechanic_model.g.dart';

@JsonSerializable()
class MechanicModel extends Equatable {
  final String id;
  final String name;
  final String phone;
  final String? email;
  final double rating;
  final int totalReviews;
  final double? distance; // in kilometers
  final List<String> services;
  final String? priceRange; // e.g., "10000 - 50000"
  final bool verified;
  final String? profilePictureUrl;
  final String? workshopName;
  final String? workshopAddress;
  final double? latitude;
  final double? longitude;
  final bool isAvailable;
  final int? estimatedArrivalMinutes;
  final String? specialization;

  const MechanicModel({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    this.rating = 0.0,
    this.totalReviews = 0,
    this.distance,
    this.services = const [],
    this.priceRange,
    this.verified = false,
    this.profilePictureUrl,
    this.workshopName,
    this.workshopAddress,
    this.latitude,
    this.longitude,
    this.isAvailable = true,
    this.estimatedArrivalMinutes,
    this.specialization,
  });

  factory MechanicModel.fromJson(Map<String, dynamic> json) =>
      _$MechanicModelFromJson(json);

  Map<String, dynamic> toJson() => _$MechanicModelToJson(this);

  MechanicModel copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    double? rating,
    int? totalReviews,
    double? distance,
    List<String>? services,
    String? priceRange,
    bool? verified,
    String? profilePictureUrl,
    String? workshopName,
    String? workshopAddress,
    double? latitude,
    double? longitude,
    bool? isAvailable,
    int? estimatedArrivalMinutes,
    String? specialization,
  }) {
    return MechanicModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      rating: rating ?? this.rating,
      totalReviews: totalReviews ?? this.totalReviews,
      distance: distance ?? this.distance,
      services: services ?? this.services,
      priceRange: priceRange ?? this.priceRange,
      verified: verified ?? this.verified,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      workshopName: workshopName ?? this.workshopName,
      workshopAddress: workshopAddress ?? this.workshopAddress,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isAvailable: isAvailable ?? this.isAvailable,
      estimatedArrivalMinutes: estimatedArrivalMinutes ?? this.estimatedArrivalMinutes,
      specialization: specialization ?? this.specialization,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        phone,
        email,
        rating,
        totalReviews,
        distance,
        services,
        priceRange,
        verified,
        profilePictureUrl,
        workshopName,
        workshopAddress,
        latitude,
        longitude,
        isAvailable,
        estimatedArrivalMinutes,
        specialization,
      ];
}

